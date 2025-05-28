package com.demo.configurations;

import com.demo.dtos.TestDTO;
import com.demo.entities.Rank;
import com.demo.entities.Test;
import org.modelmapper.ModelMapper;

import org.modelmapper.PropertyMap;
import org.modelmapper.TypeMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
public class ModelMapperConfiguration {
    @Autowired
    private Environment environment;

    @Bean
    public ModelMapper modelMapper() {
        ModelMapper mapper = new ModelMapper();

        // Ánh xạ thủ công số câu hỏi
        mapper.addMappings(new PropertyMap<Test, TestDTO>() {
            @Override
            protected void configure() {
//                using(ctx -> {
//                    Test source = (Test) ctx.getSource();
//                    if (source.getTestDetails() == null) {
//                        return 0;
//                    } else {
//                        return source.getTestDetails().size();
//                    }
//                }).map(source, destination.getNumberOfQuestions());

                // Thêm ánh xạ cho Rank (chuyển từ Rank sang Integer - id)
                using(ctx -> {
                    Rank rank = ((Test) ctx.getSource()).getRank();
                    return rank != null ? rank.getId() : null;
                }).map(source, destination.getRank());
            }
        });

        return mapper;
    }


}