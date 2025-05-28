package com.demo.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "simulator")
public class Simulator {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        @Column(name = "title")
        private String title;

        @Column(name = "description")
        private String description;

        @Column(name = "video_link")
        private String videoLink;

        @Column(name = "image")
        private String image;

        @Column(name = "video_length")
        private Integer videoLength;

        @Column(name = "danger_second")
        private Integer dangerSecond;

        @Column(name = "guide_description")
        private String guideDescription;

        @Column(name = "guide_image")
        private String guideImage;

        @Column(name = "status")
        private Byte status;

        @ManyToOne
        @JoinColumn(name = "chapter_simulator_id")
        private ChapterSimulator chapterSimulator;

    public ChapterSimulator getChapterSimulator() {
        return chapterSimulator;
    }

    public void setChapterSimulator(ChapterSimulator chapterSimulator) {
        this.chapterSimulator = chapterSimulator;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Integer getVideoLength() {
        return videoLength;
    }

    public void setVideoLength(Integer videoLength) {
        this.videoLength = videoLength;
    }

    public Integer getDangerSecond() {
        return dangerSecond;
    }

    public void setDangerSecond(Integer dangerSecond) {
        this.dangerSecond = dangerSecond;
    }

    public String getGuideDescription() {
        return guideDescription;
    }

    public void setGuideDescription(String guideDescription) {
        this.guideDescription = guideDescription;
    }

    public String getGuideImage() {
        return guideImage;
    }

    public void setGuideImage(String guideImage) {
        this.guideImage = guideImage;
    }

    public Byte getStatus() {
        return status;
    }

    public void setStatus(Byte status) {
        this.status = status;
    }
}