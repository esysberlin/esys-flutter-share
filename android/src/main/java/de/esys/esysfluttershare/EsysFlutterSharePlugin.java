package de.esys.esysfluttershare;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import androidx.core.content.FileProvider;

import java.io.File;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * EsysFlutterSharePlugin
 */
public class EsysFlutterSharePlugin implements MethodCallHandler {

    private Registrar _registrar;

    private EsysFlutterSharePlugin(Registrar registrar) {
        this._registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "channel:github.com/orgs/esysberlin/esys-flutter-share");
        channel.setMethodCallHandler(new EsysFlutterSharePlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("shareImage")) {
            shareImage(call.arguments);
        } else if (call.method.equals("shareText")) {
            shareText(call.arguments);
        } else {
            result.notImplemented();
        }
    }

     private void shareImage(Object arguments) {

        HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
        String fileName = (String) argsMap.get("fileName");
        String title = (String) argsMap.get("title");

        Context activeContext = _registrar.activeContext();

        File imageFile = new File(activeContext.getCacheDir(), fileName);
        String fileProviderAuthority = activeContext.getPackageName() + ".fileprovider.github.com/orgs/esysberlin/esys-flutter-share";
        Uri contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, imageFile);
        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("image/*");
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
        activeContext.startActivity(Intent.createChooser(shareIntent, title));
    }

    private void shareText(Object arguments) {

        HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
        String textToSend = (String) argsMap.get("text");
        String title = (String) argsMap.get("title");

        Context activeContext = _registrar.activeContext();

        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("text/plain");
        shareIntent.putExtra(Intent.EXTRA_TEXT, textToSend);
        activeContext.startActivity(Intent.createChooser(shareIntent, title));
    }
}
