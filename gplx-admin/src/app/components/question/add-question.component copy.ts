import { Component, OnInit } from '@angular/core';
import { BaseUrlService } from 'src/app/service/baseUrl.service';
import { QuestionService } from 'src/app/service/question.service';

@Component({
  selector: 'app-root',
  templateUrl: './add-question.component.html',
  styleUrls: ['./question.component.css'],
})
export class AddQuestionComponent implements OnInit {
  constructor(
    private baseUrlService: BaseUrlService,
    private questionService: QuestionService
  ) {}

  imageUrl: string | ArrayBuffer | null = null;
  imageFile: File | null = null;
  answers: { text: string; isCorrect: boolean }[] = [];
  questionContent: string = '';
  failed: boolean = false;
  explain: string = '';
  listQuestion: any = {};
  listQuestionOriginal: any = {};
  questionDetail: any = {};
  linkImage: string = this.baseUrlService.getImageUrl();

  ngOnInit(): void {
    // Không cần gọi findAll() vì component này chỉ để thêm câu hỏi
  }

  onImageUpload(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      if (!file.type.startsWith('image/')) {
        alert('Chỉ được chọn tệp hình ảnh!');
        return;
      }

      this.imageFile = file;

      const reader = new FileReader();
      reader.onload = () => {
        this.imageUrl = reader.result;
      };
      reader.readAsDataURL(file);
    }
  }

  addAnswerField() {
    this.answers.push({ text: '', isCorrect: false });
  }

  removeAnswerField(index: number) {
    this.answers.splice(index, 1);
  }

  saveQuestion() {
    const questionData = {
      content: this.questionContent,
      failed: this.failed,
      explain: this.explain,
      answers: this.answers,
    };

    this.questionService
      .addQuestion(questionData, this.imageFile)
      .then((res) => {
        console.log('Thêm câu hỏi thành công:', res);
        alert('Thêm câu hỏi thành công!');
        this.resetForm();
        setTimeout(() => {
          window.location.href = '/question';
        }, 1000);
      })
      .catch((error) => {
        console.error('Lỗi khi thêm câu hỏi:', error);
        alert(
          'Có lỗi xảy ra khi thêm câu hỏi: ' +
            (error.message || 'Không xác định')
        );
      });
  }

  resetForm() {
    this.questionContent = '';
    this.failed = false;
    this.explain = '';
    this.imageUrl = null;
    this.imageFile = null;
    this.answers = [];
    const imageInput = document.getElementById(
      'imageUpload'
    ) as HTMLInputElement;
    if (imageInput) {
      imageInput.value = '';
    }
  }

  searchQuestion(evt: any) {
    const keyWord = evt.target.value.toLowerCase().trim();

    if (keyWord === '') {
      this.listQuestion = [...this.listQuestionOriginal];
    } else {
      this.listQuestion = this.listQuestionOriginal.filter((question: any) => {
        const content = question.content?.toLowerCase() || '';
        return content.includes(keyWord);
      });
    }
  }

  questionDetails(id: any) {
    this.questionService.findById(id).then((res) => {
      console.log(res);
      this.questionDetail = res;
    });
  }

  goToQuestion() {
    window.location.href = '/question';
  }
}
