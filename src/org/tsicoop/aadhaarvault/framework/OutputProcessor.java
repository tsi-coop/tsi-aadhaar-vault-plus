package org.tsicoop.aadhaarvault.framework;

import jakarta.servlet.ServletOutputStream;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import jakarta.servlet.http.HttpServletResponse;

import java.io.OutputStream;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;

public class OutputProcessor {

    public static final String MEDIA_TYPE_JSON = "application/json";

     private static final DateTimeFormatter ISO_INSTANT_FORMATTER = DateTimeFormatter.ISO_INSTANT.withZone(ZoneOffset.UTC);

    public static void errorResponse(HttpServletResponse res,int status, String error, String message, String path) {
        JSONObject errorNode = new JSONObject();
        ServletOutputStream out = null;
        errorNode.put("timestamp", ISO_INSTANT_FORMATTER.format(Instant.now()));
        errorNode.put("status", status);
        errorNode.put("error", error);
        errorNode.put("message", message);
        errorNode.put("path", path);
        try {
            out = res.getOutputStream();
            out.print(errorNode.toJSONString());
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            if (out != null) {
                try {
                    out.flush();
                    out.close();
                }catch(Exception ignore){}
            }
        }
    }

    public static void send(HttpServletResponse res, int status, Object data) {
        ServletOutputStream out = null;
        try {
            res.setContentType(MEDIA_TYPE_JSON);
            res.setCharacterEncoding("UTF-8");
            res.setStatus(status);
            out = res.getOutputStream();
            if (data != null) {
                if (data instanceof byte[]) {
                    out.write((byte[]) data);
                } else {
                    out.print(String.valueOf(data));
                }
            }
        } catch (Exception e) {
        }finally {
        if (out != null) {
            try {
                out.flush();
                out.close();
            }catch(Exception ignore){}
        }
    }
    }

    public static void sendError(HttpServletResponse res, int status, String message) {
        ServletOutputStream out = null;
        res.setContentType(MEDIA_TYPE_JSON);
        res.setCharacterEncoding("UTF-8");
        res.setStatus(status);
        JSONObject resp = new JSONObject();
        resp.put("status", status);
        resp.put("error", message);
        try {
            out = res.getOutputStream();
            out.print(String.valueOf(out));
        } catch (Exception e) {
        } finally {
            if (out != null) {
                try {
                    out.flush();
                    out.close();
                } catch (Exception ignore) {
                }
            }
        }
    }
}
