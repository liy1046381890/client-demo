package com.example.myapplication.activity;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import com.example.myapplication.R;
import com.example.myapplication.utils.PhoneUtils;

import java.lang.ref.WeakReference;
import java.net.InetAddress;

public class HomeActivity extends AppCompatActivity {
    private TextView ip;
    private TextView mac;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        ip = findViewById(R.id.ip);
        mac = findViewById(R.id.mac);
        Button btnOut = findViewById(R.id.btn_out);
        btnOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent in = new Intent(HomeActivity.this, LoginActivity.class);
                startActivity(in);
            }
        });

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                new MyTask(HomeActivity.this).execute();
            }
        }, 1000);
    }

    private static class MyTask extends AsyncTask<String, Integer, String> {

        private WeakReference<HomeActivity> weakReference;

        MyTask(HomeActivity activity) {
            this.weakReference = new WeakReference<>(activity);
        }

        @Override
        protected String doInBackground(String... params) {
            InetAddress ipAddress = PhoneUtils.getIpAddress();
            String ip = null != ipAddress ? ipAddress.getHostAddress() : null;
            String mac = PhoneUtils.getMacAddressFromIp();
            return ip + "\r\n" + mac;
        }

        @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            HomeActivity activity = weakReference.get();
            if (activity == null || activity.isFinishing() || activity.isDestroyed()) {
                return;
            }
            String[] ts = s.split("\r\n");
            activity.ip.setText(ts[0]);
            activity.mac.setText(ts[1]);
        }

        @Override
        protected void onCancelled() {
            super.onCancelled();
        }
    }
}
