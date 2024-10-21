class AuthService {
  Future<void> sendOtp(String phoneNumber) async {
    // Implement your OTP sending logic here
    print('Sending OTP to $phoneNumber');
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    // Implement your OTP verification logic here
    print('Verifying OTP for $phoneNumber');
  }
}
