import 'package:flutter/material.dart'; 
import 'package:url_launcher/url_launcher.dart'; 

class sendingMessage extends StatelessWidget { // sendingMessage 클래스는 StatelessWidget을 상속받아 생성됨
  void _sendSMS(String message, List<String> recipients) async { // SMS 전송 함수 정의
    String _message = Uri.encodeComponent(message); // 메시지를 URI 형식으로 인코딩
    String _recipients = recipients.join(','); // 수신자 리스트를 ','로 구분된 문자열로 변환
    String _url = 'sms:$_recipients?body=$_message'; // SMS URL 생성

    if (await canLaunch(_url)) { // URL을 실행할 수 있는지 확인
      await launch(_url); // URL 실행, SMS 앱으로 전환됨
    } else {
      throw 'Could not launch $_url'; // URL 실행 실패 시 예외 발생
    }
  }

  @override
  Widget build(BuildContext context) { // 위젯 빌드 메서드
    return Scaffold( // 기본적인 스캐폴드 레이아웃
      appBar: AppBar( // 상단 앱바 설정
        title: Text('Send SMS Example'), // 앱바에 표시할 제목
      ),
      body: Center( // 중앙에 컨텐츠 배치
        child: ElevatedButton( // 눌렀을 때 동작하는 버튼 생성
          onPressed: () { // 버튼 클릭 시 동작
            _sendSMS('Hello, this is a test message!', ['01023209299']); // 버튼 클릭 시 SMS 전송 함수 호출
          },
          child: Text('Send SMS'), // 버튼에 표시할 텍스트
        ),
      ),
    );
  }
}
