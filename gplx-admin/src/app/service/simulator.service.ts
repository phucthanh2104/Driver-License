import { Injectable } from "@angular/core";
import { BaseUrlService } from "./baseUrl.service";
import { HttpClient } from "@angular/common/http";
import { lastValueFrom } from 'rxjs';

@Injectable()
export class SimualtorService {
  constructor(
    private baseUrlService: BaseUrlService,
    private httpClient: HttpClient
  ) {}

  async findAll(): Promise<any> {
    return await lastValueFrom(
      this.httpClient.get(this.baseUrlService.getBaseUrl() + 'simulator/findAll'));
  }

  async findBySimulatorId(id: number): Promise<any> {
    return await lastValueFrom(
      this.httpClient.get(
        this.baseUrlService.getBaseUrl() + 'simulator/findBySimulatorId/' + id));
  }

  async delete(id: any): Promise<any> {
    return await lastValueFrom(
      this.httpClient.post(
        this.baseUrlService.getBaseUrl() + 'question/deleteQuestion/' + id,
        {}
      )
    );
  }

  async update(
    id: number,
    questionData: any,
    imageFile: File | null
  ): Promise<any> {
    try {
      const formData = new FormData();
      // Thêm questionData dưới dạng JSON string
      formData.append('question', JSON.stringify(questionData));
      // Thêm file hình ảnh nếu có
      if (imageFile) {
        formData.append('image', imageFile);
      }

      const response = await lastValueFrom(
        this.httpClient.post(
          `${this.baseUrlService.getBaseUrl()}question/updateQuestion/${id}`,
          formData
        )
      );
      return response;
    } catch (error) {
      console.error('Lỗi khi cập nhật câu hỏi:', error);
      throw error; // Ném lỗi để QuestionComponent xử lý
    }
  }
 
}