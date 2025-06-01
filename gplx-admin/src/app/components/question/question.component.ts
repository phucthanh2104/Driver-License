import { Component, OnInit } from '@angular/core';
import { BaseUrlService } from 'src/app/service/baseUrl.service';
import { QuestionService } from 'src/app/service/question.service';

@Component({
  selector: 'app-root',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.css'],
})
export class QuestionComponent implements OnInit {
  constructor(
    private baseUrlService: BaseUrlService,
    private questionService: QuestionService
  ) {}
  imageUrl: string | ArrayBuffer | null = null;
  answers: { text: string; isCorrect: boolean }[] = [];
  questionContent: string = '';
  isCritical: boolean = false;
  listQuestion: any = {};
  listQuestionOriginal: any = {};

  ngOnInit(): void {
    this.findAll();
  }
  findAll() {
    this.questionService
      .findAll()
      .then((res) => {
        console.log('Danh sách câu hỏi:', res);
        this.listQuestionOriginal = res; // Lưu danh sách gốc
        this.listQuestion = [...this.listQuestionOriginal]; // Khởi tạo danh sách hiển thị
      })
      .catch((error) => {
        console.error('Lỗi khi lấy danh sách câu hỏi:', error);
        this.listQuestion = [];
        this.listQuestionOriginal = [];
      });
  }

  onImageUpload(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      const reader = new FileReader();
      reader.onload = () => {
        this.imageUrl = reader.result;
      };
      reader.readAsDataURL(file);
    }
  }

  // Thêm một trường nhập câu trả lời
  addAnswerField() {
    this.answers.push({ text: '', isCorrect: false });
  }

  // Xóa một trường câu trả lời
  removeAnswerField(index: number) {
    this.answers.splice(index, 1); // Xóa câu trả lời tại vị trí index
  }

  // Lưu câu hỏi
  saveQuestion() {
    const questionData = {
      content: this.questionContent,
      isCritical: this.isCritical,
      image: this.imageUrl,
      answers: this.answers,
    };
    console.log('Dữ liệu câu hỏi:', questionData);
    this.resetForm();
  }

  // Reset form sau khi lưu
  resetForm() {
    this.questionContent = '';
    this.isCritical = false;
    this.imageUrl = null;
    this.answers = [];
  }

  searchQuestion(evt: any) {
    const keyWord = evt.target.value.toLowerCase().trim();
    
    if (keyWord === '') {
      // Nếu từ khóa rỗng, khôi phục danh sách gốc
      this.listQuestion = [...this.listQuestionOriginal];
    } else {
      // Lọc danh sách câu hỏi dựa trên từ khóa
      this.listQuestion = this.listQuestionOriginal.filter((question) => {
        const content = question.content?.toLowerCase() || '';
        return content.includes(keyWord);
      });
    }
  }
}