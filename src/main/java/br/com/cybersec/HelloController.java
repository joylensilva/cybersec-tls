package br.com.cybersec;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello Secure World!";
    }

    @GetMapping("/hello-big-content")
    public String helloBigContent() {
        return "Hello Secure World! ".repeat(1000);
    }

}
