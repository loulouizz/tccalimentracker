  import 'package:alimentracker/auth.dart';
import 'package:alimentracker/firebase_options.dart';
  import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';

  class MockUser extends Mock implements User{}

  final MockUser _mockUser = MockUser();

  class MockFirebaseAuth extends Mock implements FirebaseAuth {
    @override
    Stream<User?> authStateChanges() {
      return Stream.fromIterable([
        MockUser()
      ]);
    }
  }

  void main (){
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
    final Auth auth = Auth();

    test('description', (){
      expectLater(auth.authStateChanges, emitsInOrder([_mockUser]));
    });
  }

  // teste unitario de login só para verificar se o email/cpf é válido
  // testar os dados quanto à entrada e saída