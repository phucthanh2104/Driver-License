import { Injectable } from "@angular/core";
import { BaseUrlService } from "./baseUrl.service";
import { HttpClient } from "@angular/common/http";
import { lastValueFrom } from 'rxjs';

@Injectable()
export class QuestionService {
  constructor(
    private baseUrlService: BaseUrlService,
    private httpClient: HttpClient
  ) {}

  async findAll(): Promise<any> {
    return await lastValueFrom(
      this.httpClient.get(this.baseUrlService.getBaseUrl() + 'question/findAll')
    );
  }

  async findById(id: number): Promise<any> {
    return await lastValueFrom(
      this.httpClient.get(
        this.baseUrlService.getBaseUrl() + 'question/findById/' + id
      )
    );
  }

  async delete(id: any): Promise<any> {
    return await lastValueFrom(
      this.httpClient.post(
        this.baseUrlService.getBaseUrl() + 'question/deleteQuestion/' + id,
        {}
      )
    );
  }

  async update(id: number,questionData: any,imageFile: File | null): Promise<any> {
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
  async addQuestion(questionDTO: any, imageFile?: File): Promise<any> {
    const formData = new FormData();

    // Thêm questionDTO dưới dạng chuỗi JSON
    formData.append(
      'question',
      JSON.stringify({
        content: questionDTO.content,
        explain: questionDTO.explain || '', // Nếu không có giải thích, để rỗng
        status: questionDTO.status || true, // Mặc định là true nếu không có
        rankA: questionDTO.isCritical || false, // isCritical tương ứng với rankA
        failed: questionDTO.failed || false, // Mặc định là false nếu không có
        answers: questionDTO.answers.map((answer: any) => ({
          content: answer.text,
          status: answer.status || true, // Mặc định là true nếu không có
          correct: answer.isCorrect,
        })),
      })
    );

    // Thêm file ảnh nếu có
    if (imageFile) {
      formData.append('image', imageFile);
    }

    return await lastValueFrom(
      this.httpClient.post(
        this.baseUrlService.getBaseUrl() + 'question/addQuestion',
        formData
      )
    );
  }
}