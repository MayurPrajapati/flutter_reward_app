package com.mayur.flutter_reward_app

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.facebook.FacebookSdk
import com.google.firebase.FirebaseApp


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    FacebookSdk.sdkInitialize(this)
    FirebaseApp.initializeApp(this)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
