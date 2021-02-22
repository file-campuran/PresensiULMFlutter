const translate = require('./translate.js')

const to = 'ja';

let example = {
    "home": "Beranda",
    "message": "Pesan",
    "notification": "Pemberitahuan",
    "account": "Akun",
    "change_language": "Ubah Bahasa",
    "dynamic_theme": "Sistem Telepon",
    "always_on": "Selalu Hidup",
    "always_off": "Selalu Mati",
    "about_us": "Tentang kami",
    "search": "Cari ...",
    "password": "Password",
    "confirm": "Konfirmasi",
    "understand": "Mengerti",
    "apply": "Menerapkan",
    "contact_us": "Hubungi kami",
    "name": "Nama",
    "input_name": "Masukkan nama Anda",
    "email": "Email",
    "input_email": "Masukkan email Anda",
    "information": "Informasi",
    "input_information": "Masukkan informasi Anda",
    "value_not_empty": "Masukan tidak boleh kosong",
    "value_not_valid_range": "Input bukan kisaran yang valid",
    "value_not_valid_email": "Masukan bukan email yang valid",
    "value_not_valid_phone": "Masukan telepon tidak valid",
    "value_not_valid_password": "Masukkan kata sandi yang tidak valid",
    "value_not_valid_id": "Masukkan bukan ID yang valid",
    "edit_profile": "Ubah Biodata",
    "address": "Alamat",
    "input_address": "Masukkan alamat Anda",
    "title": "Judul",
    "input_title": "Masukkan judul Anda",
    "description": "Deskripsi",
    "font": "Font",
    "forgot_password": "Tidak ingat kata sandi",
    "more": "Lebih",
    "delete": "Menghapus",
    "image": "Gambar",
    "profile": "Profil",
    "sign_out": "Keluar",
    "sign_in": "Masuk",
    "setting": "Pengaturan",
    "loading": "Memuat...",
    "clear": "Bersih",
    "language": "Bahasa",
    "theme": "Tema",
    "dark_mode": "Mode Gelap",
    "version": "Versi",
    "default": "Default",
    "brown": "Cokelat",
    "pink": "Merah Jambu",
    "orange": "Jeruk",
    "green": "Hijau",
    "yellow": "Kuning",
    "close": "Menutup",
    "pull_down_refresh": "Tarik ke bawah, segarkan",
    "refreshing": "Segar...",
    "refresh_completed": "Penyegaran selesai",
    "release_to_refresh": "Lepaskan untuk menyegarkan",
    "release_to_load_more": "Lepaskan untuk memuat lebih banyak",
    "pull_to_load_more": "Tarik untuk memuat lebih banyak",
    "phone_number": "Nomor telepon",
    "blood_type": "Golongan darah",
    "history": "Riwayat",
    "privacy_policy": "Syarat & Ketentuan",
    "presence": "Presensi",
    "attendance_schedule": "Jadwal Presensi",
    "attendance_history": "Riwayat Presensi",
    "change_view": "Ubah Tampilan",
    "map": "Peta",
    "list": "List",
    "confirm_sign_out": "Apakah anda yakin ingin keluar?",
    "location": "Lokasi",
    "guide": "Panduan",
    "location_timeout": "Batas pencarian lokasi telah habis",
    "ask_location": "Mohon aktifkan GPS pada perangkat anda",
    "get_location": "Mengambil data lokasi sekarang",
    "performance_description": "Keterangan Kinerja",
    "choose_file": "Pilih berkas",
    "change_file": "Ubah berkas",
    "choose_file_empty": "Tidak ada berkas yang dipilih",
    "error_internal_server": "Terjadi kesalahan pada server",
    "application_error": "Terjadi kesalahan pada aplikasi",
    "format_exception": "Format server tidak valid",
    "network_error": "Tidak ada koneksi internet",
    "page_not_found": "Halaman tidak ditemukan",
    "was_error_the_server": "Terjadi kesalahan di server",
    "redirect": "Halaman dialihkan",
    "cant_connect_server": "Tidak terhubung ke server",
    "slide1_title": "Presensi ULM",
    "slide1_content": "Digunakan oleh tenaga pendidik dan tenaga kependidikan (dosen)",
    "slide2_title": "Kepegawaian",
    "slide2_content": "Data presensi dikelola oleh bagian kepegawaian ULM",
    "slide3_title": "Pengunaan",
    "slide3_content": "Lakukan presensi di manapun menggunakan smartphone anda dengan menggunakan kamera dan gps yang terhubung ke internet",
    "ask_quit": "Tap 2x untuk keluar aplikasi",
    "privacy_policy_title": "Data Anda akan kami amankan dan tidak akan pernah di akses, kecuali jika anda memberikan akun anda ke orang lain. ",
    "customer_service": "Pelayanan pelanggan",
    "mark_all_read": "Tandai baca semua",
    "help_center": "Pusat Bantuan",
    "select_location": "Pilih Lokasi",
    "there_is_no": "Tidak ada",
};

(async() => {
    // translateByOne();
    translateBatch();
})()

/**
 * Translator
 * @param {*} word 
 */
async function myTranslate(word) {
    let trans = await translate(word, to);
    if (!trans) return;
    return trans.word;
}

/**
 * Translate JSON String
 */
async function translateBatch() {
    let orign = example;
    example = Object.keys(example).map((key) => `[${example[key]}]`)

    try {
        let word = await myTranslate(JSON.stringify(example));
        // console.log('WORD', word)
        // word = word.replace(/]/g, '');
        word = word.replace(/、/g, ',');
        word = word.replace(/「/g, '');
        word = word.replace(/」/g, '');
        // console.log('REPLACE', word)
        // console.log('PARSE', JSON.parse(word))

        let data = JSON.parse(word);
        let index = 0;
        Object.keys(orign).map((key) => {
            data[index] = data[index].replace('[', '');
            data[index] = data[index].replace(']', '');
            orign[key] = data[index];
            index++;
        });
        console.log('PARSE', orign)
    } catch (error) {
        console.warn('ERROR', error);
    }
}

/**
 * Translate JSON Value one by one
 */
async function translateByOne() {
    console.log('EXAMPLE', example);

    await Promise.all(Object.keys(example).map(async(key) => {
        example[key] = await myTranslate(example[key]);
    }));

    console.log('TRANSLATE', example);
}