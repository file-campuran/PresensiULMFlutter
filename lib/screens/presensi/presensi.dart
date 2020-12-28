import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';

import 'package:image_editor/image_editor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:presensi/utilities/Services/MlVision.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:device_info/device_info.dart';
import 'package:trust_fall/trust_fall.dart';
import 'package:path/path.dart' show join;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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

  var infoPresensi;
  var responseStatus;

  bool isSendPresensi = false;

  final double _initFabHeight = 120.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  CameraController controller;
  bool isReady = false;
  bool showCamera = true;

  final Set<Marker> _markers = {};

  double latitude, longitude;
  bool mocked;
  String imagePath;
  String filePath;
  String deskripsi;
  bool isRoot = false, isFakeGps, isIos;
  bool isRefreshLoading = false;
  bool isRealDevice = true;

  Map<String, dynamic> deviceInfo = Map();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  Size imageSize;
  Face faceDetected;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setupCameras();
    getLocation();
    initPlatformState();
    initPresensi();
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

  void getLocation() {
    MyLocation()
      ..getLoacation().then((position) => setState(() {
            latitude = position.latitude;
            longitude = position.longitude;
            isFakeGps = position.mocked;

            print('LATITUDE');
            print(latitude);

            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId("3.595196, 98.672226"),
                position: LatLng(position.latitude, position.longitude),
                icon: BitmapDescriptor.defaultMarker,
              ),
            );
          }));
  }

  void initPresensi() {
    // apiProvider.getInfoPresensi().then((value) => setState(() {
    //       infoPresensi = value;
    //       responseStatus = value;
    //       isRefreshLoading = false;
    //     }));
  }

  Future<void> sendPresensi() async {
    Map<String, dynamic> dataPresensi = new Map();
    dataPresensi['latitude'] = latitude;
    dataPresensi['longitude'] = longitude;
    dataPresensi['deskripsi'] = deskripsi;
    dataPresensi['isRoot'] = isRoot;
    dataPresensi['isFakeGps'] = isFakeGps;
    dataPresensi['isIos'] = Platform.isIOS;
    dataPresensi['isEmulator'] = !isRealDevice;
    dataPresensi['deviceInfo'] = jsonEncode(deviceInfo);
    dataPresensi['face_data'] = null;

    dataPresensi['foto'] = await MultipartFile.fromFile(
      imagePath,
      filename: imagePath.split("/")?.last + '.jpg',
    );

    try {
      dataPresensi['berkas'] = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split("/")?.last,
      );
    } catch (e) {}

    setState(() {
      isSendPresensi = true;
    });
  }

  chooseFile() async {
    try {
      File file = await FilePicker.getFile();
      setState(() {
        filePath = file.path;
      });
    } catch (e) {}
  }

  Widget buttonTake(
      {IconData icon, double size = 55, background: true, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          icon,
          size: size / 2.5,
          color: Colors.white,
        ),
        decoration: background
            ? BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                shape: BoxShape.circle,
                /* boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 8.0,
              )
            ] */
              )
            : BoxDecoration(),
      ),
    );
  }

  Widget BodyResponse() {
    return mainPresensi();
  }

  @override
  Widget build(BuildContext context) {
    return BodyResponse();
  }

  Widget mainPresensi() {
    _panelHeightOpen = MediaQuery.of(context).size.height * .6;
    _panelHeightClosed = MediaQuery.of(context).size.height * .26;

    return Theme(
        data: Theme.of(context).copyWith(
          brightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.indigo,
          body: Scaffold(
              body: GestureDetector(
                  onTap: () {
                    print('HIDE');
                    FocusScope.of(context).unfocus();
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      SlidingUpPanel(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Colors.grey,
                            ),
                          ],
                          backdropEnabled: true,
                          maxHeight: _panelHeightOpen,
                          minHeight: _panelHeightClosed,
                          parallaxEnabled: false,
                          parallaxOffset: .5,
                          body: Container(
                            child: Stack(
                              // fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height -
                                      _panelHeightClosed +
                                      65,
                                  child: showCamera
                                      ? cameraPreviewWidget()
                                      : imagePreviewWidget(),
                                ),
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
                                Positioned(
                                  right: 0,
                                  top: 30,
                                  child: toggleWidget(),
                                ),
                                // Positioned(
                                //   top: 20,
                                //   child: CustomAppBarWidget(),
                                // ),
                                Positioned(
                                    width: MediaQuery.of(context).size.width,
                                    bottom: _panelHeightClosed + 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        showCamera
                                            ? buttonTake(
                                                icon: Icons.camera_enhance,
                                                onTap: () {
                                                  // _cameraService.dispose();
                                                  // _cameraService.startService(
                                                  //     CameraLensDirection.back);
                                                  // _cameraService.toggleCamera();

                                                  print('CAPTURE');
                                                  onTakePictureButtonPressed();
                                                })
                                            : buttonTake(
                                                icon: Icons.refresh,
                                                onTap: () {
                                                  print('RE CAPTURE');
                                                  editCaptureControlRowWidget();
                                                }),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          panelBuilder: (sc) => _panel(sc),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18.0),
                              topRight: Radius.circular(18.0)),
                          // onPanelSlide: (double pos) => setState(() {
                          //   _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                          //       _initFabHeight;
                          // }),
                          onPanelSlide: (double pos) {
                            // print(pos);
                          }),

                      // the fab
                      imagePath != null
                          ? Positioned(
                              right: 20.0,
                              bottom: 20,
                              child: FloatingActionButton(
                                child: !isSendPresensi
                                    ? Icon(Icons.fingerprint,
                                        color: Colors.white)
                                    : CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.grey),
                                      ),
                                onPressed: () {
                                  if (!isSendPresensi) {
                                    sendPresensi();
                                  }
                                },
                                backgroundColor: isSendPresensi
                                    ? Colors.grey
                                    : Colors.orange,
                              ),
                            )
                          : Container(),
                    ],
                  ))),
        ));
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(children: <Widget>[
          Container(
            // color: Colors.orange,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 6.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: new ScrollBehavior()
                ..buildViewportChrome(context, null, AxisDirection.down),
              child: ListView(
                controller: sc,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset(
                          Images.Writting,
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Presensi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Keterangan Kinerja",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 4),
                        TextFormField(
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
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.orange,
                                  // textColor: Colors.white,
                                  onPressed: chooseFile,
                                  child: Text(filePath == null
                                      ? 'Pilih Berkas'
                                      : 'Ubah Berkas'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    filePath != null
                                        ? filePath.split("/")?.last
                                        : 'Tidak ada berkas yang dipilih',
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "infoPresensi['upload_info']['maks']",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              "infoPresensi['upload_info']['allowed_type']",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Lokasi",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          height: 12.0,
                        ),
                        longitude != null
                            ? Container(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(latitude, longitude),
                                        zoom: 14.4746,
                                      ),
                                      markers: _markers,
                                    )),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  void showInSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget imagePreviewWidget() {
    return Container(
      child: imagePath == null
          ? null
          : FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _image.width.toDouble(),
                height: _image.height.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(_image, _faces),
                ),
              ),
            ),
    );
    //       Image.file(File(imagePath),
    // fit: BoxFit.cover,
    // width: double.infinity,
    // height: double.infinity));
  }

  Widget dragIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  //FUNCTION CAMERA
  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[1], ResolutionPreset.high,
          enableAudio: true);
      await controller.initialize();

      getLocation();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  Widget captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null && controller.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }

  void onTakePictureButtonPressed() async {
    String filePath = await takePicture();
    // takePicture().then((String filePath) {
    if (mounted) {
      if (controller.description.lensDirection == CameraLensDirection.front) {
        flipImage(filePath);
      } else {
        File file = new File(filePath);

        detectedImage(file);
      }
    }
    // });
  }

  Future flipImage(String filePath) async {
    print('controller');
    print(controller.description.lensDirection);
    final editorOption = ImageEditorOption();
    editorOption.addOption(FlipOption(horizontal: true));
    // editorOption.addOption(ClipOption());
    editorOption.outputFormat = OutputFormat.jpeg(88);

    File file = new File(filePath);
    var image = await ImageEditor.editFileImageAndGetFile(
        file: file, imageEditorOption: editorOption);

    if (image != null) {
      detectedImage(image);
    }
  }

  String user;
  Future detectedImage(File file) async {
    final images = FirebaseVisionImage.fromFile(file);

    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(images);

    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        imagePath = file.path;
        showCamera = false;

        _faces = faces;
        _image = value;

        for (var item in faces) {
          print('ITEMS');
          print(item.trackingId);
        }

        controller.startImageStream((image) {
          controller.stopImageStream();

          if (faces.length != 0) {
            // _faceNetService.setCurrentPrediction(image, faces[0]);
            print('_faceNetService.predictedData');
            // user = _faceNetService.predict();
            // print('USER ' + user);
          } else {
            user = '';
          }
        });
      }),
    );
  }

  ui.Image _image;
  List<Face> _faces;

  Widget cameraPreviewWidget() {
    if (!isReady || !controller.value.isInitialized) {
      return Text('Tidak Ready');
    }

    Size size = MediaQuery.of(context).size;

    return AspectRatio(aspectRatio: 3 / 1, child: CameraPreview(controller));

    return Container(child: CameraPreview(controller));

    return Container(
      child: CameraPreview(controller),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    print(controller.value);

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
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
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showInSnackBar('Camera error ${e}');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget toggleWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showCamera ? cameraTogglesRowWidget() : Container(),
        ],
      ),
    );
  }

  Widget cameraTogglesRowWidget() {
    if (isReady) {
      return controller.description.lensDirection == CameraLensDirection.front
          ? buttonTake(
              icon: Icons.camera_rear,
              size: 50,
              background: false,
              onTap: () {
                onNewCameraSelected(cameras[0]);
              })
          : buttonTake(
              icon: Icons.camera_front,
              size: 50,
              background: false,
              onTap: () {
                onNewCameraSelected(cameras[1]);
              });
    }

    return Container();
  }

  void editCaptureControlRowWidget() {
    setState(() {
      user = '';
      showCamera = true;
      imagePath = null;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
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
      // 'app_version': Dictionary.version,
      // 'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
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

  //END FUNCTION
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;

    final Paint me = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.orange;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], i == 0 ? me : paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
