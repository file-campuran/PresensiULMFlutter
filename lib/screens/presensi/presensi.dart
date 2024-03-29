import 'dart:convert';

import 'package:absen_online/screens/default/location/location.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:lottie/lottie.dart' hide Marker;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:image_editor/image_editor.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:device_info/device_info.dart';
import 'package:trust_fall/trust_fall.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/models/model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:absen_online/api/geocoder_repository.dart';
import 'package:absen_online/utils/api/multipart_file_extended.dart';
import 'dart:ui' as ui;

List<CameraDescription> cameras;

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

class Presensi extends StatefulWidget {
  const Presensi({Key key}) : super(key: key);

  PresensiState createState() => PresensiState();
}

class PresensiState extends State<Presensi> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> _infoData;
  Map<String, dynamic> _errorData;

  bool isSendPresensi = false;
  bool pageDetail = false;

  double _bottomPanelSliderHeightOpen;
  double _bottomPanelSliderHeightClosed = 95.0;

  CameraController controller;
  bool isReady = false;
  bool showCamera = true;

  double latitude, longitude, accuracy = 0;
  Position myPosition;
  String myAddress = '';
  MyLocationModel myArea;

  bool mocked;
  String imagePath;
  String filePath;
  String deskripsi;
  bool isRoot = false, isFakeGps = false, isIos = false;
  bool isRefreshLoading = false;
  bool isRealDevice = true;

  Map<String, dynamic> deviceInfo = Map();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool cameraInitializated = false;
  bool pictureTaked = false;

  Size imageSize;
  Face faceDetected;
  FaceListModel faceModel;

  bool _btnLoading = false;
  bool _btnCameraLoading = false;
  JadwalModel _infoPresensi;
  FaceDetector faceDetector;

  int _startPresensi = 0;
  int _endPresensi = 0;

  LocationError errorLocation = new LocationError();
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }
  JadwalCubit _jadwalCubit;

  @override
  void dispose() {
    controller.dispose();
    positionStream.cancel();

    if (Platform.isAndroid) {
      faceDetector.close();
    }
    // myLocation.closeStream();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _jadwalCubit = BlocProvider.of<JadwalCubit>(context);

    setupCameras();
    _getLocation();

    if (Platform.isAndroid) {
      initFirebaseML();
    }
    initPlatformState();
    initPresensi();
    checkBiodata();
    initLokasiPresensi();
    initPengaturan();
    initKecamatan();
  }

  void initLokasiPresensi() async {
    final response = await PresensiRepository().getLokasiPresensi();

    if (response.code == CODE.SUCCESS) {
      final lokasiModel = LokasiPresensiListModel.fromMap(response.data);

      setState(() {
        Application.lokasiPresensiList = lokasiModel;
      });
    }
  }

  void initKecamatan() async {
    final response = await PresensiRepository().getKecamatan();

    if (response.code == CODE.SUCCESS) {
      final lokasiModel = KecamatanListModel.fromMap(response.data);

      setState(() {
        Application.kecamatanListModel = lokasiModel;
      });
    }
  }

  void initPengaturan() async {
    final response = await PresensiRepository().getPengaturanPresensi();

    if (response.code == CODE.SUCCESS) {
      final lokasiModel = PengaturanListModel.fromMap(response.data);

      setState(() {
        Application.pengaturanList = lokasiModel;
      });
    }
  }

  void checkBiodata() {
    final user = Application.user;
    if (user.alamatRumahPresensi == '' &&
        user.noHp == '' &&
        user.golDarah == '') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, Routes.editProfile, arguments: false);
      });
    }
  }

  void initFirebaseML() {
    faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        mode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      isRoot = await TrustFall.isJailBroken;
      isRealDevice = await TrustFall.isRealDevice;

      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch (e) {}

    setState(() {
      deviceInfo = deviceData;
    });
  }

  final myLocation = MyLocation();
  StreamSubscription<Position> positionStream;
  void _getLocation() async {
    setState(() {
      errorLocation.message = '';
      errorLocation.status = false;
    });

    // myAddress = await GeocoderRepository().getAddress(
    //       latitude: position.latitude, longitude: position.longitude);
    positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
            .listen((Position position) {});

    positionStream.onError((handleError) {
      if (this.mounted) {
        setState(() {
          errorLocation.message =
              Translate.of(context).translate(handleError.toString());
          errorLocation.status = true;
        });
        UtilLogger.log('ERROR', handleError.toString());
      }
    });

    positionStream.onData((position) async {
      UtilLogger.log('ACCURACY', position.accuracy);
      UtilLogger.log('DATA', position);
      final myAreaStatusBefore = myArea?.message;
      myArea = myLocation.inAreaPresensi(position);

      if (myArea.message != myAreaStatusBefore) {
        setState(() {});
      }

      if (this.mounted) {
        if (accuracy > position.accuracy || accuracy == 0) {
          myPosition = position;
          accuracy = double.parse(position.accuracy.toStringAsFixed(4));
          latitude = position.latitude;
          longitude = position.longitude;
          isFakeGps = position.isMocked;
          myAddress = await GeocoderRepository().getAddress(
              latitude: position.latitude, longitude: position.longitude);
          setState(() {});
        }
      }
    });
    // setState(() {
    //   errorLocation.message = '';
    //   errorLocation.status = false;
    // });

    // final isEnabled = await myLocation.gpsServiceEnable();
    // if (isEnabled) {
    //   UtilLogger.log('LOCATION', 'SERVICE LOCATION IS ENABLE');
    // } else {
    //   setState(() {
    //     errorLocation.message = Translate.of(context).translate('ask_location');
    //     errorLocation.status = true;
    //   });

    //   UtilLogger.log('LOCATION', 'SERVICE LOCATION IS DISABLED');
    // }

    // final position = await myLocation.getLoacation();
    // UtilLogger.log('LOCATION', 'POSITION INITIALIZE');
    // if (position != null) {
    //   myArea = myLocation.inAreaPresensi();
    //   myAddress = await GeocoderRepository().getAddress(
    //       latitude: position.latitude, longitude: position.longitude);
    //   if (this.mounted) {
    //     setState(() {
    //       myPosition = position;
    //       latitude = position.latitude;
    //       longitude = position.longitude;
    //       isFakeGps = position.isMocked;
    //     });
    //   }
    // } else {
    //   setState(() {
    //     errorLocation.message =
    //         Translate.of(context).translate('location_timeout');
    //     errorLocation.status = true;
    //   });
    // }
  }

  void initPresensi() {
    setState(() {
      _startPresensi = DateTime.now().millisecondsSinceEpoch;
      _btnLoading = true;
    });
    PresensiRepository().getDetailPresensi().then((result) {
      if (this.mounted) {
        setState(() {
          _btnLoading = false;
        });
        if (result.code == CODE.SUCCESS) {
          setState(() {
            _errorData = null;
            _infoPresensi = JadwalModel.fromJson(result.data);
          });
        } else if (result.code == CODE.INFO) {
          String title = (result.message is String)
              ? 'Informasi'
              : result.message['title'];
          String message = (result.message is String)
              ? result.message
              : result.message['content'];
          setState(() {
            _errorData = null;
            _infoData = {
              'title': title,
              'content': message,
              'image': result.message is String
                  ? Images.KonfirmasiPresensi
                  : Images.Calendar,
            };
          });
        } else if (result.code == CODE.TOKEN_EXPIRED) {
          BlocProvider.of<LoginBloc>(context).add(OnLogout());
        } else {
          setState(() {
            _errorData = result.message;
          });
        }
      }
    });
  }

  Future<void> sendPresensi() async {
    Map<String, dynamic> dataPresensi = new Map();
    dataPresensi['status'] = _infoPresensi.ruleStatus;
    dataPresensi['latitude'] = latitude;
    dataPresensi['longitude'] = longitude;
    dataPresensi['deskripsiKinerja'] = deskripsi;
    dataPresensi['deviceIsRoot'] = isRoot ? 1 : 0;
    dataPresensi['deviceIsFakeGps'] = isFakeGps ? 1 : 0;
    dataPresensi['deviceIsIos'] = Platform.isIOS ? 1 : 0;
    // dataPresensi['isEmulator'] = !isRealDevice;
    dataPresensi['deviceInfo'] = jsonEncode(deviceInfo);
    dataPresensi['faceData'] = faceModel.toString();

    UtilLogger.log('DATA PRESENSIS', dataPresensi);
    // dataPresensi['face_data'] = _faces;

    try {
      final fileGambarName = imagePath.split("/").last + '.jpg';
      UtilLogger.log('FILE GAMBAR', fileGambarName);
      UtilLogger.log('FILE GAMBAR PATH', imagePath);

      dataPresensi['fileGambar'] = MultipartFileExtended.fromFileSync(
        imagePath,
        filename: fileGambarName,
        contentType: MediaType("*", "*"),
      );
    } catch (e) {}

    if (filePath != null) {
      final fileBerkasName = filePath.split("/").last;
      UtilLogger.log('FILE BERKAS', fileBerkasName);
      UtilLogger.log('FILE BERKAS PATH', filePath);
      dataPresensi['fileBerkas'] = MultipartFileExtended.fromFileSync(
        filePath,
        filename: fileBerkasName,
        contentType: MediaType("*", "*"),
      );
    }

    try {
      setState(() {
        isSendPresensi = true;
      });
      final response = await PresensiRepository().setPresensi(dataPresensi);

      if (response.code == CODE.SUCCESS) {
        // Delete temporary files
        try {
          File _tempFile = File(imagePath);
          _tempFile.delete();
        } catch (e) {}
        // Set event time presensi
        _endPresensi = DateTime.now().millisecondsSinceEpoch;
        AnalyticsHelper.setLogEvent(Analytics.timmerPresensi,
            {'time_ms': (_endPresensi - _startPresensi)});

        _jadwalCubit.reInit();
        setState(() {
          _infoData = {
            'title': 'Informasi',
            'content': 'Terimakasih sudah melakukan presensi',
            'image': Images.KonfirmasiPresensi,
          };
        });
      } else {
        setState(() {
          isSendPresensi = false;
        });
        appMyInfoDialog(
            context: context, title: 'Info', message: response.message);
      }
    } catch (e) {
      print(e);
    }
  }

  chooseFile() async {
    try {
      FilePickerResult file = await FilePicker.platform.pickFiles();
      setState(() {
        filePath = file.paths.first;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_errorData != null) {
      return AppError(
        title: _errorData['title'].toString(),
        message: _errorData['content'].toString(),
        image: _errorData['image'],
        onPress: initPresensi,
        btnRefreshLoading: _btnLoading,
      );
    }

    if (_infoData != null) {
      return _buildInfo();
    } else if (_infoPresensi != null) {
      return _buildContent();
    }

    return Center(child: AppColorLoader());
  }

  Widget _buildInfo() {
    return Scaffold(
      body: AppInfo(
        title: _infoData['title'].toString(),
        message: _infoData['content'].toString(),
        image: _infoData['image'],
      ),
    );
  }

  Widget _buildContent() {
    _bottomPanelSliderHeightOpen = MediaQuery.of(context).size.height * .6;
    _bottomPanelSliderHeightClosed = MediaQuery.of(context).size.height * .28;

    return Scaffold(
      // floatingActionButton: _buttonSendPresensi(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
              backdropEnabled: true,
              maxHeight: _bottomPanelSliderHeightOpen,
              minHeight: _bottomPanelSliderHeightClosed,
              parallaxEnabled: false,
              parallaxOffset: .5,
              body: _panelBody(),
              panelBuilder: (sc) => _bottomPanelSlider(sc),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
            // FAB
            _buttonSendPresensi()
          ],
        ),
      ),
    );
  }

  /*
   * Panel Atas memuat camera 
   */
  Widget _panelBody() {
    return Container(
      child: Stack(
        children: <Widget>[
          // CAMERA PREVIEW
          Container(
            height: MediaQuery.of(context).size.height -
                _bottomPanelSliderHeightClosed +
                65,
            child: showCamera ? cameraPreviewWidget() : imagePreviewWidget(),
          ),
          // BACKDROP
          Positioned(
            top: 0,
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    // Colors.black12,
                    Colors.black45,
                    Colors.black.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          // TOGGLE WIDGET
          Positioned(
            right: 0,
            top: 30,
            child: _toggleWidget(),
          ),
          //BUTTON CAPTURE
          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: _bottomPanelSliderHeightClosed +
                  80 +
                  (Platform.isIOS ? 20 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  showCamera
                      ? AppTransparentButton(
                          icon: Icons.camera_enhance,
                          isLoading: _btnCameraLoading,
                          onTap: () {
                            print('CAPTURE');
                            eventTakePicture();
                          })
                      : AppTransparentButton(
                          icon: Icons.refresh,
                          onTap: () {
                            print('RE CAPTURE');
                            eventRecapture();
                          }),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buttonSendPresensi() {
    // if (imagePath != null) {
    return Positioned(
      right: 20.0,
      bottom: 20,
      child: FloatingActionButton(
        heroTag: 'sendPresensi',
        child: !isSendPresensi
            ? MyIconDuotone(
                MyIconDuotoneIcon.save_close,
                color: Colors.white,
              )
            : CupertinoActivityIndicator(),
        onPressed: () {
          if (!isSendPresensi) {
            sendPresensi();
          }
        },
        backgroundColor:
            isSendPresensi ? Colors.grey : Theme.of(context).primaryColor,
      ),
    );
    // }

    // return Container();
  }

  /*
   * Panel Bottom
   * Memilih berkas
   * Keterangan Kinerja 
   */
  Widget _bottomPanelSlider(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 6.0,
                  ),
                  AppDragCapsule(),
                  SizedBox(
                    height: 6.0,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      // Lottie.asset(
                      //   Images.Writting,
                      //   width: 35,
                      //   height: 35,
                      // ),
                      MyIconDuotone(
                        MyIconDuotoneIcon.address,
                      ),
                      // Icon(EvaIcons.bookOpenOutline),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        Translate.of(context).translate('presence') +
                            " ${_infoPresensi?.ruleStatus}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                  if (myPosition != null) ...[
                    InkWell(
                        child: Icon(
                            !pageDetail ? Icons.list : Icons.article_outlined),
                        onTap: () {
                          setState(() {
                            pageDetail = !pageDetail;
                          });
                        }),
                  ],
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: new ScrollBehavior()
                  ..buildViewportChrome(context, null, AxisDirection.down),
                child: ListView(
                  controller: sc,
                  children: <Widget>[
                    pageDetail
                        ? _bottomPanelSliderContent2()
                        : _bottomPanelSliderContent(),
                    SizedBox(
                      height: 36.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomPanelSliderContent() {
    if (latitude != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            wDetailLokasi(),
            Text(Translate.of(context).translate('performance_description'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 4),
            TextFormField(
              initialValue: deskripsi,
              keyboardType: TextInputType.multiline,
              // maxLines: 3,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  deskripsi = value;
                });
              },
              decoration: InputDecoration(
                // labelText: 'Keterangan Kerja',
                contentPadding: EdgeInsets.all(15.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).highlightColor, width: 1.0),
                ),
              ),
            ),
            if (_infoPresensi.ruleIsUploadFile) ...[
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: AppButton(
                          onPressed: chooseFile,
                          text: filePath == null
                              ? Translate.of(context).translate('choose_file')
                              : Translate.of(context).translate('change_file'),
                          disableTouchWhenLoading: true,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: filePath != null
                            ? AppFilenameIcon(
                                fileName: filePath.split("/")?.last,
                                onTap: () {
                                  print('ONTAO');
                                  setState(() {
                                    filePath = null;
                                  });
                                },
                              )
                            : Text(
                                Translate.of(context)
                                    .translate('choose_file_empty'),
                                softWrap: true,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    Application.remoteConfig.presensi.upload.max,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    Application.remoteConfig.presensi.upload.mime,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              )
            ]
          ],
        ),
      );
    } else {
      return Column(children: [
        if (errorLocation.status) ...[
          SizedBox(
            height: 20,
          ),
          Text(errorLocation.message),
          SizedBox(
            height: 20,
          ),
          AppMyButton(
            loading: false,
            text: 'Reload',
            icon: Icons.refresh,
            onPress: _getLocation,
          ),
        ] else ...[
          AppColorLoader(),
          Text(Translate.of(context).translate('get_location')),
        ]
      ]);
    }
  }

  Widget wDetailLokasi() {
    final keteranganYa = Application.pengaturanList
        .getSettingConfig('presensi_berbasis_lokasi_keterangan_ya');
    final keteranganTidak = Application.pengaturanList
        .getSettingConfig('presensi_berbasis_lokasi_keterangan_tidak');
    final berbasisLokasi =
        Application.pengaturanList.getSettingConfig('presensi_berbasis_lokasi');

    return Column(
      children: [
        if (keteranganYa.isNotEmpty && keteranganTidak.isNotEmpty) ...[
          _itemContent2(
            title: berbasisLokasi == '1' ? keteranganYa : keteranganTidak,
            icon: Icons.info_outline,
            color: berbasisLokasi == '1' ? Colors.orange : Colors.green,
          ),
        ],
        _itemContent2(
            title: 'Status Presensi',
            content: myArea.message,
            isLoading: Application.kecamatanListModel == null ||
                Application.lokasiPresensiList == null,
            icon: Icons.radio_button_on_sharp,
            color: myArea.status ? Colors.green : Colors.red,
            onTap: () {
              // #TODO FIX THIS (Disabled)
              if (false) {
                Navigator.of(context).pushNamed(Routes.location,
                    arguments:
                        LocationModel(1, 'Lokasi Saya', latitude, longitude));
              }
            }),

        // #TODO FIX THIS (Disabled)
        if (false) ...[
          Row(
            children: [
              SizedBox(width: 40),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 100,
                    child: Location(
                      title: null,
                      location:
                          LocationModel(1, 'Lokasi Saya', latitude, longitude),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
        _itemContent2(
            icon: Icons.location_on_outlined,
            title: 'Latitude, Longitude',
            content: "$latitude, $longitude"),
        _itemContent2(
            icon: Icons.vpn_lock_outlined,
            title: 'Akurasi GPS (Semakin kecil, semakin akurat)',
            content: "$accuracy meters"),
        _itemContent2(
            title: 'Lokasi Sekarang',
            content: myAddress,
            icon: Icons.location_on),
        _itemContent2(
            icon: Icons.edit_location_outlined,
            title: 'Fake GPS',
            content: myPosition?.isMocked == null
                ? ''
                : myPosition.isMocked
                    ? 'Ya'
                    : 'Tidak'),
        _itemContent2(
            icon: Icons.phonelink_lock,
            title:
                Platform.isAndroid ? 'Terdeteksi Root' : 'Terdeteksi Jailbreak',
            content: isRoot ? 'Ya' : 'Tidak'),
      ],
    );
  }

  Widget _bottomPanelSliderContent2() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
      child: wDetailLokasi(),
    );
  }

  Widget _itemContent2(
      {String title,
      String content,
      IconData icon,
      Color color,
      bool isLoading = false,
      Function onTap}) {
    return Container(
      padding: EdgeInsets.only(bottom: Dimens.padding),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Visibility(
              // visible: icon != null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).dividerColor),
                child: Icon(
                  icon ?? Icons.access_time,
                  color: color ?? Colors.white,
                  size: 18,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (isLoading) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeleton(
                            borderRadius: BorderRadius.circular(3),
                            height: 13,
                            width: 90,
                          ),
                          SizedBox(height: 5),
                          AppSkeleton(
                            borderRadius: BorderRadius.circular(3),
                            height: 13,
                          ),
                        ],
                      ),
                    ] else ...[
                      if (title != null) ...[
                        Text(
                          title ?? '',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      if (content != null) ...[
                        Container(
                          width: Adapt.screenW() * 0.80,
                          child: Text(
                            content ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget imagePreviewWidget() {
    // return AspectRatio(
    //   aspectRatio: 3 / 1,
    //   child: FittedBox(
    //     fit: BoxFit.cover,
    //     child: Image.file(File(imagePath)),
    //   ),
    // );
    if (_image == null) {
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.file(File(imagePath), fit: BoxFit.cover),
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: Text('DETECTING FACE'),
          // ),
        ],
      );
    }
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _image.width.toDouble(),
          height: _image.height.toDouble(),
          child: CustomPaint(
            painter: AppFacePainter(_image, _faces ?? []),
          ),
        ),
      ),
    );
  }

  Widget cameraPreviewWidget() {
    if (!isReady || !controller.value.isInitialized) {
      return Center(
        child: AppColorLoader(),
      );
    }

    return AspectRatio(aspectRatio: 3 / 1, child: CameraPreview(controller));
  }

  CameraDescription cameraDescription(CameraLensDirection lensDirection) {
    return cameras.firstWhere(
      (CameraDescription camera) => camera.lensDirection == lensDirection,
    );
  }

  //FUNCTION CAMERA
  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(
          cameraDescription(CameraLensDirection.front), ResolutionPreset.high,
          enableAudio: false);
      await controller.initialize();
    } on CameraException catch (_) {
      controller?.dispose();
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  int startTime = 0;
  int endTime = 0;
  int calculateTime = 0;
  void eventTakePicture() async {
    setState(() {
      _btnCameraLoading = true;
    });

    startTime = DateTime.now().millisecondsSinceEpoch;
    UtilLogger.log('INIT TAKE PICTURE', startTime.toString());

    String filePath = await takePicture();

    endTime = DateTime.now().millisecondsSinceEpoch;
    calculateTime = (endTime - startTime);

    UtilLogger.log('COMPLETE TAKE TIME', "$calculateTime ms");
    AnalyticsHelper.setLogEvent(
        Analytics.timmerTakePicture, {'time_ms': calculateTime});

    UtilLogger.log('TAKE PICTURE PATH', filePath);
    if (mounted) {
      // #TODO FIX THIS
      if (controller.description.lensDirection == CameraLensDirection.front &&
          Platform.isAndroid) {
        flipImage(filePath);
      } else {
        File file = new File(filePath);

        detectedImage(file);
      }
    }
  }

  Future flipImage(String filePath) async {
    UtilLogger.log('START FLIP PICTURE', DateTime.now().toString());

    final editorOption = ImageEditorOption();
    editorOption.addOption(FlipOption(horizontal: true));
    editorOption.outputFormat = OutputFormat.jpeg(88);

    File file = new File(filePath);
    File flipImage = await ImageEditor.editFileImageAndGetFile(
        file: file, imageEditorOption: editorOption);
    file.delete();

    UtilLogger.log('COMPLETE FLIP PICTURE', flipImage.path);
    detectedImage(flipImage);
  }

  Future detectedImage(File fileRaw) async {
    setState(() {
      imagePath = fileRaw.path;
      showCamera = false;
      _btnCameraLoading = false;
    });

    startTime = DateTime.now().millisecondsSinceEpoch;
    UtilLogger.log('START DETECT FACE IMAGE', startTime.toString());

    List<Face> faces;
    if (Platform.isAndroid) {
      final visionImage = FirebaseVisionImage.fromFile(fileRaw);
      faces = await faceDetector.processImage(visionImage);
    }

    final dataFaceFirebase = await fileRaw.readAsBytes();
    final decodeImage = await decodeImageFromList(dataFaceFirebase);

    endTime = DateTime.now().millisecondsSinceEpoch;
    calculateTime = (endTime - startTime);

    UtilLogger.log('END DETECT FACE IMAGE', "$calculateTime ms");
    AnalyticsHelper.setLogEvent(
        Analytics.timmerFaceDetection, {'time_ms': calculateTime});

    // Change Face Object to String model
    try {
      faceModel = FaceListModel.fromJson(faces);
      UtilLogger.log('FACES', faceModel.toString());
    } catch (e) {}

    setState(() {
      // imagePath = fileRaw.path;
      // showCamera = false;
      // _btnCameraLoading = false;

      _faces = faces;
      _image = decodeImage;
    });
  }

  ui.Image _image;
  List<Face> _faces;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/presensi';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (_) {
      return null;
    }
    return filePath;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        controller?.dispose();
        // showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      controller?.dispose();
      // showInSnackBar('Camera error $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _toggleWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showCamera ? _cameraTogglesRowWidget() : Container(),

          // #TODO FIX THIS (DISABLED)
          if (false) ...[
            AppTransparentButton(
                icon: Icons.location_on,
                size: 50,
                background: false,
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.location,
                      arguments: LocationModel(1, '', latitude, longitude));
                  // _getLocation();
                }),
          ],
        ],
      ),
    );
  }

  Widget _cameraTogglesRowWidget() {
    if (isReady) {
      return controller.description.lensDirection == CameraLensDirection.front
          ? AppTransparentButton(
              icon: Icons.camera_rear,
              size: 50,
              background: false,
              onTap: () {
                onNewCameraSelected(
                    cameraDescription(CameraLensDirection.back));
              })
          : AppTransparentButton(
              icon: Icons.camera_front,
              size: 50,
              background: false,
              onTap: () {
                onNewCameraSelected(
                    cameraDescription(CameraLensDirection.front));
              });
    }

    return Container();
  }

  void eventRecapture() {
    setState(() {
      showCamera = true;
      imagePath = null;
      _image = null;
    });
    try {
      File _tempFile = File(imagePath);
      _tempFile.delete();
    } catch (e) {}
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'app_version': Environment.VERSION,
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'app_version': Environment.VERSION,
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      // 'app_version': Dictionary.version,
    };
  }
}

class LocationError {
  bool status = false;
  String message = '';

  LocationError({this.status, this.message});
}
