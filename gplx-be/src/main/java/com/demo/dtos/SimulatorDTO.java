package com.demo.dtos;

public class SimulatorDTO {

    private Integer id;
    private String title;
    private String description;
    private String videoLink;
    private String image;
    private Integer videoLength;
    private Integer dangerSecond;
    private String guideDescription;
    private String guideImage;
    private Boolean status;

    // Getters and Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
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

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }
}