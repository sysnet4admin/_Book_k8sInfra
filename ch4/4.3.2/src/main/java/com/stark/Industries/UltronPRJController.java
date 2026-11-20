package com.stark.Industries;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UltronPRJController {

    @RequestMapping("/")
    public String hello(HttpServletRequest request){
        String result = "src: "+request.getRemoteAddr()+" / dest: "+request.getServerName()+"\n";
        return result;
    }
}
