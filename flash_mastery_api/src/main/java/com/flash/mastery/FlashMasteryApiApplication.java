package com.flash.mastery;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.flash.mastery.repository")
public class FlashMasteryApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(FlashMasteryApiApplication.class, args);
    }

}
