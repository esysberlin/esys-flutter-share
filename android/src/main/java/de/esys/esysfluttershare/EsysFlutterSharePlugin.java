package de.esys.esysfluttershare;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** EsysfluttersharePlugin */
public class EsysFlutterSharePlugin implements FlutterPlugin, MethodCallHandler {

    private final String PROVIDER_AUTH_EXT = ".fileprovider.github.com/orgs/esysberlin/esys-flutter-share";

    private MethodChannel channel;
    private FlutterPluginBinding binding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "channel:github.com/orgs/esysberlin/esys-flutter-share");
        binding = flutterPluginBinding;
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("text")) {
            text(call.arguments);
        }
        if (call.method.equals("file")) {
            file(call.arguments);
        }
        if (call.method.equals("files")) {
            files(call.arguments);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void text(Object arguments) {
        @SuppressWarnings("unchecked")
        HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
        String title = argsMap.get("title");
        String text = argsMap.get("text");
        String mimeType = argsMap.get("mimeType");

        Context activeContext = binding.getApplicationContext();

        Intent shareIntent = new Intent(Intent.ACTION_SEND);

        shareIntent.setType(mimeType);
        shareIntent.putExtra(Intent.EXTRA_TEXT, text);
        Intent chooserIntent = Intent.createChooser(shareIntent, title);
        chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        chooserIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        activeContext.startActivity(chooserIntent);
    }

    private void file(Object arguments) {
        @SuppressWarnings("unchecked")
        HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
        String title = argsMap.get("title");
        String name = argsMap.get("name");
        String mimeType = argsMap.get("mimeType");
        String text = argsMap.get("text");

        Context activeContext = binding.getApplicationContext();

        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType(mimeType);
        File file = new File(activeContext.getCacheDir(), name);
        String fileProviderAuthority = activeContext.getPackageName() + PROVIDER_AUTH_EXT;
        Uri contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, file);
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
        // add optional text
        if (!text.isEmpty()) shareIntent.putExtra(Intent.EXTRA_TEXT, text);
        Intent chooserIntent = Intent.createChooser(shareIntent, title);
        chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        List<ResolveInfo> resInfoList = activeContext.getPackageManager().queryIntentActivities(chooserIntent, PackageManager.MATCH_DEFAULT_ONLY);

        for (ResolveInfo resolveInfo : resInfoList) {
            String packageName = resolveInfo.activityInfo.packageName;
            activeContext.grantUriPermission(packageName, contentUri, Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
        }
        activeContext.startActivity(chooserIntent);
    }

    private void files(Object arguments) {
        @SuppressWarnings("unchecked")
        HashMap<String, Object> argsMap = (HashMap<String, Object>) arguments;
        String title = (String) argsMap.get("title");

        @SuppressWarnings("unchecked")
        ArrayList<String> names = (ArrayList<String>) argsMap.get("names");
        ArrayList<String> mimeTypes = (ArrayList<String>) argsMap.get("mimeTypes");
        String text = (String) argsMap.get("text");

        Context activeContext = binding.getApplicationContext();
        Intent shareIntent = new Intent();

        ArrayList<Uri> contentUris = new ArrayList<>();

        for (String name : names) {
            File file = new File(activeContext.getCacheDir(), name);
            String fileProviderAuthority = activeContext.getPackageName() + PROVIDER_AUTH_EXT;
            Uri contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, file);
            contentUris.add(contentUri);
        }
        
        if (contentUris.size() == 1) {
            shareIntent.setAction(Intent.ACTION_SEND);
            shareIntent.putExtra(Intent.EXTRA_STREAM, contentUris.get(0));
        } else {
            shareIntent.setAction(Intent.ACTION_SEND_MULTIPLE);
            shareIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, contentUris);
        }

        String mimeType = reduceMimeTypes(mimeTypes);
        shareIntent.setType(mimeType);

        if (!text.isEmpty()) shareIntent.putExtra(Intent.EXTRA_TEXT, text);
        
        Intent chooserIntent = Intent.createChooser(shareIntent, title);

        List<ResolveInfo> resInfoList = activeContext.getPackageManager().queryIntentActivities(chooserIntent, PackageManager.MATCH_DEFAULT_ONLY);

        for (ResolveInfo resolveInfo : resInfoList) {
            String packageName = resolveInfo.activityInfo.packageName;
            for(Uri uri: contentUris){
                activeContext.grantUriPermission(packageName, uri, Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
            }
        }
        chooserIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activeContext.startActivity(chooserIntent);
    }

    /**
     * Reduces provided MIME types to a common one to provide [Intent] with a correct type
     * to share multiple files
     */
    private String reduceMimeTypes(ArrayList<String> mimeTypes) {
        String reducedMimeType = "*/*";
        int size = mimeTypes.size();

        if (size == 1) {
            reducedMimeType = mimeTypes.get(0);
        } else if (size > 1) {
            String commonMimeType = mimeTypes.get(0);
            String commonMimeTypeBase = getMimeTypeBase(commonMimeType);
            for (int i = 1; i < size; ++i) {
                String iterabelType = mimeTypes.get(i);
                if (!commonMimeType.equals(iterabelType)) {
                    String iterableTypeBase = getMimeTypeBase(iterabelType);
                    if (commonMimeTypeBase == iterableTypeBase) {
                        commonMimeType = iterableTypeBase + "/*";
                    } else {
                        commonMimeType = "*/*";
                        break;
                    }
                }
            }
            reducedMimeType = commonMimeType;
        }
        return reducedMimeType;
    }

    /**
     * Returns the first part of provided MIME type, which comes before '/' symbol
     */
    private String getMimeTypeBase(String mimeType) {
        if (mimeType == null || !mimeType.contains("/")) {
            return "*";
        } else {
            return mimeType.substring(0, mimeType.indexOf("/"));
        }
    }
}