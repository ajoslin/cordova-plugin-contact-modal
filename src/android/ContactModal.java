package org.ajoslin.contactmodal;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.provider.ContactsContract;
import android.provider.ContactsContract.Intents;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class ContactModal extends CordovaPlugin {

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    JSONObject json;
    json = args.getJSONObject(0);
    this.openCreateContact(json, callbackContext);
    callbackContext.success();
    return true;
  }

  private void openCreateContact(final JSONObject json, CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
          @Override
          public void run() {
              Context context = cordova.getActivity()
                      .getApplicationContext();

              // Creates a new Intent to insert a contact
              Intent intent = new Intent(Intents.Insert.ACTION);
              // Sets the MIME type to match the Contacts Provider
              intent.setType(ContactsContract.RawContacts.CONTENT_TYPE);

              intent.putExtra(Intents.Insert.NAME, safeGetJSONString(json, "firstName") + " " + safeGetJSONString(json, "lastName"));
              intent.putExtra(Intents.Insert.COMPANY, safeGetJSONString(json, "organization"));
              intent.putExtra(Intents.Insert.JOB_TITLE, safeGetJSONString(json, "title"));

              intent.putExtra(Intents.Insert.PHONE, safeGetJSONString(json, "workPhone"));
              intent.putExtra(Intents.Insert.PHONE_TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK);
              intent.putExtra(Intents.Insert.PHONE, safeGetJSONString(json, "cellPhone"));
              intent.putExtra(Intents.Insert.PHONE_TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);
              intent.putExtra(Intents.Insert.PHONE, safeGetJSONString(json, "directPhone"));
              intent.putExtra(Intents.Insert.PHONE_TYPE, "Direct Dial");

              intent.putExtra(Intents.Insert.EMAIL, safeGetJSONString(json, "workEmail"));
              intent.putExtra(Intents.Insert.EMAIL_TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK);
              intent.putExtra(Intents.Insert.EMAIL, safeGetJSONString(json, "externalEmail"));
              intent.putExtra(Intents.Insert.EMAIL_TYPE, "External");

              intent.putExtra(Intents.Insert.SECONDARY_PHONE, safeGetJSONString(json, "cellPhone"));
              intent.putExtra(Intents.Insert.SECONDARY_PHONE_TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);
              cordova.getActivity().startActivity(intent);
          }
      });
  }

  private String safeGetJSONString(JSONObject json, String jsonKey) {
    try {
      return json.getString(jsonKey);
    }
    catch (JSONException userJSONError) {
      return "";
    }
  }

}
