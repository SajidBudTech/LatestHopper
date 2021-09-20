class RegisterToken {
  String tokenType;
  int iat;
  int expiresIn;
  String jwtToken;

  RegisterToken({this.tokenType, this.iat, this.expiresIn, this.jwtToken});

  RegisterToken.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    iat = json['iat'];
    expiresIn = json['expires_in'];
    jwtToken = json['jwt_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = this.tokenType;
    data['iat'] = this.iat;
    data['expires_in'] = this.expiresIn;
    data['jwt_token'] = this.jwtToken;
    return data;
  }
}