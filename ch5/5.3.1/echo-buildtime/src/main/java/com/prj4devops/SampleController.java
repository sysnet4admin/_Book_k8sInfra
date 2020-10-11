package com.prj4devops;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.net.InetAddress;
import java.net.UnknownHostException;

class ResultEntity {
    private String version;
    private String src;
    private String dest;
    private String hostname;

    public ResultEntity(String src, String dest, String hostname, String version) {
        this.src = src;
        this.dest = dest;
        this.hostname = hostname;
        this.version = version;
    }

    public String getSrc() {
        return src;
    }

    public void setSrc(String src) {
        this.src = src;
    }

    public String getDest() {
        return dest;
    }

    public void setDest(String dest) {
        this.dest = dest;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }
}

@RestController
public class SampleController {

    private String version;

    public SampleController(@Value("${build.version}") String version) {
        this.version = version;
    }

    @RequestMapping("/")
    public ResultEntity hello(HttpServletRequest request) throws UnknownHostException {
        String hostname= InetAddress.getLocalHost().getHostName();
        return new ResultEntity(request.getRemoteAddr(), request.getServerName(), hostname, version);
    }
}
