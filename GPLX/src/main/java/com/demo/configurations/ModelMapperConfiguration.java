package com.demo.configurations;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.modelmapper.ModelMapper;

@Configuration
public class ModelMapperConfiguration {

    @Bean
    public ModelMapper modelMapper() {
        ModelMapper mapper = new ModelMapper();
//            mapper.addMappings(new PropertyMap<Orderdetails, OrderDeatailsDTO>() {
//            @Override
//            protected void configure() {
//                map().setCdTitle(source.getCd().getTitle());
//            }
//        });

        return mapper;
    }
}
