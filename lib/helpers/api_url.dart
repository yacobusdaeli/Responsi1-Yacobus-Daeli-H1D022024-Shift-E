class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';
  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listPenerbit = baseUrl + 'api/buku/penerbit';
  static const String createPenerbit = baseUrl + 'api/buku/penerbit';

  static String updatePenerbit(int id) {
    return baseUrl + 'api/buku/penerbit/' + id.toString() + '/update';
  }

  static String showPenerbit(int id) {
    return baseUrl + 'api/buku/penerbit/' + id.toString();
  }

  static String deletePenerbit(int id) {
    return baseUrl + 'api/buku/penerbit/' + id.toString() + '/delete';
  }
}
