import { Component, OnInit } from '@angular/core';
import { ConfirmationService, MessageService } from 'primeng/api';
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
    private questionService: QuestionService,
    private confirmationService: ConfirmationService,
    private messageService: MessageService
  ) {}

  // Biến cho modal sửa câu hỏi
  imageUrl: string | ArrayBuffer | null = null;
  imageFile: File | null = null;
  answers: {
    id?: number;
    content: string;
    correct: boolean;
    status: boolean;
  }[] = [];
  questionContent: string = '';
  failed: boolean = false;
  explain: string = '';
  listQuestion: any[] = [];
  listQuestionOriginal: any[] = [];
  questionDetail: any = {};
  linkImage: string = this.baseUrlService.getImageUrl();
  isEditMode: boolean = false;
  currentQuestionId: number | null = null;
  originalImage: string | null = null;
  originalQuestion: any = null;

  // Biến cho modal thêm câu hỏi mới
  newImageUrl: string | ArrayBuffer | null = null;
  newImageFile: File | null = null;
  newAnswers: { content: string; correct: boolean; status: boolean }[] = [];
  newQuestionContent: string = '';
  newFailed: boolean = false;
  newExplain: string = '';

  // Pagination properties
  currentPage: number = 1;
  pageSize: number = 10;
  totalEntries: number = 0;
  pageSizes: number[] = [10, 50, 100, 600];

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.questionService
      .findAll()
      .then((res) => {
    
        this.listQuestionOriginal = res.map((question: any) => {
          if (question.image) {
            question.imageUrl = `${this.baseUrlService.getImageUrl()}/${
              question.image
            }`;
          } else {
            question.imageUrl = null;
          }
          return question;
        });
        this.totalEntries = this.listQuestionOriginal.length;
        this.updatePaginatedList();
      })
      .catch((error) => {
        console.error('Lỗi khi lấy danh sách câu hỏi:', error);
        this.listQuestion = [];
        this.listQuestionOriginal = [];
        this.totalEntries = 0;
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail:
            'Không thể tải danh sách câu hỏi: ' +
            (error.message || 'Không xác định'),
          life: 3000,
        });
      });
  }

  updatePaginatedList() {
    const start = (this.currentPage - 1) * this.pageSize;
    const end = start + this.pageSize;
    this.listQuestion = this.listQuestionOriginal.slice(start, end);
  }

  onPageSizeChange(event: Event) {
    const selectElement = event.target as HTMLSelectElement;
    this.pageSize = parseInt(selectElement.value, 10);
    this.currentPage = 1;
    this.updatePaginatedList();
  }

  previousPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.updatePaginatedList();
    }
  }

  nextPage() {
    const totalPages = Math.ceil(this.totalEntries / this.pageSize);
    if (this.currentPage < totalPages) {
      this.currentPage++;
      this.updatePaginatedList();
    }
  }

  goToPage(page: number) {
    this.currentPage = page;
    this.updatePaginatedList();
  }

  get totalPages(): number {
    return Math.ceil(this.totalEntries / this.pageSize);
  }

  get pages(): number[] {
    return Array.from({ length: this.totalPages }, (_, i) => i + 1);
  }

  // Xử lý hình ảnh cho modal sửa
  onImageUpload(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      if (!file.type.startsWith('image/')) {
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: 'Chỉ được chọn tệp hình ảnh!',
          life: 3000,
        });
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

  removeImage() {
    this.imageUrl = null;
    this.imageFile = null;
    const imageInput = document.getElementById(
      'imageUpload'
    ) as HTMLInputElement;
    if (imageInput) imageInput.value = '';
  }

  // Xử lý hình ảnh cho modal thêm
  onNewImageUpload(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      if (!file.type.startsWith('image/')) {
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: 'Chỉ được chọn tệp hình ảnh!',
          life: 3000,
        });
        return;
      }
      this.newImageFile = file;
      const reader = new FileReader();
      reader.onload = () => {
        this.newImageUrl = reader.result;
      };
      reader.readAsDataURL(file);
    }
  }

  removeNewImage() {
    this.newImageUrl = null;
    this.newImageFile = null;
    const imageInput = document.getElementById(
      'newImageUpload'
    ) as HTMLInputElement;
    if (imageInput) imageInput.value = '';
  }

  // Xử lý câu trả lời cho modal sửa
  addAnswerField() {
    this.answers.push({ content: '', correct: false, status: true });
  }

  removeAnswerField(index: number) {
    this.answers.splice(index, 1);
  }

  onAnswerCorrectChange(selectedIndex: number) {
    this.answers = this.answers.map((answer, index) => ({
      ...answer,
      correct: index === selectedIndex,
    }));
    console.log('Answers after change:', this.answers); // Debug
  }

  // Xử lý câu trả lời cho modal thêm
  addNewAnswerField() {
    this.newAnswers.push({ content: '', correct: false, status: true });
  }

  removeNewAnswerField(index: number) {
    this.newAnswers.splice(index, 1);
  }

  onNewAnswerCorrectChange(selectedIndex: number) {
    this.newAnswers = this.newAnswers.map((answer, index) => ({
      ...answer,
      correct: index === selectedIndex,
    }));
    console.log('New Answers after change:', this.newAnswers); // Debug
  }

  resetEditForm() {
    this.questionContent = '';
    this.failed = false;
    this.explain = '';
    this.imageUrl = null;
    this.imageFile = null;
    this.originalImage = null;
    this.originalQuestion = null;
    this.answers = [];
    this.isEditMode = false;
    this.currentQuestionId = null;
    const imageInput = document.getElementById(
      'imageUpload'
    ) as HTMLInputElement;
    if (imageInput) imageInput.value = '';
  }

  resetAddForm() {
    this.newQuestionContent = '';
    this.newFailed = false;
    this.newExplain = '';
    this.newImageUrl = null;
    this.newImageFile = null;
    this.newAnswers = [];
    const imageInput = document.getElementById(
      'newImageUpload'
    ) as HTMLInputElement;
    if (imageInput) imageInput.value = '';
  }

  saveQuestion() {
    const trimmedContent = this.questionContent?.trim();
    if (!trimmedContent) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Nội dung câu hỏi không được để trống!',
        life: 3000,
      });
      return;
    }

    const trimmedExplain = this.explain?.trim();
    if (!trimmedExplain) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Giải thích không được để trống!',
        life: 3000,
      });
      return;
    }

    for (let i = 0; i < this.answers.length; i++) {
      const trimmedAnswer = this.answers[i].content?.trim();
      if (!trimmedAnswer) {
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: `Nội dung câu trả lời thứ ${i + 1} không được để trống!`,
          life: 3000,
        });
        return;
      }
    }

    if (this.answers.length < 2) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Câu hỏi phải có ít nhất 2 câu trả lời!',
        life: 3000,
      });
      return;
    }

    const correctAnswerCount = this.answers.filter(
      (answer) => answer.correct
    ).length;
    if (correctAnswerCount !== 1) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Câu hỏi phải có chính xác một câu trả lời đúng!',
        life: 3000,
      });
      return;
    }

    const questionData = {
      id: this.currentQuestionId,
      content: trimmedContent,
      failed: this.failed,
      explain: trimmedExplain,
      answers: this.answers.map((answer) => ({
        id: answer.id,
        content: answer.content.trim(),
        correct: answer.correct,
        status: answer.status,
      })),
      status: true,
      rankA: this.failed,
      isFailed: this.failed,
    };

    this.questionService
      .update(this.currentQuestionId!, questionData, this.imageFile)
      .then((res) => {
        console.log('Cập nhật câu hỏi thành công:', res);
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: 'Cập nhật câu hỏi thành công!',
          life: 3000,
        });
        const modalElement = document.getElementById('questionModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }
        this.resetEditForm();
        this.findAll();
      })
      .catch((error) => {
        console.error('Lỗi khi cập nhật câu hỏi:', error);
        const errorMessage =
          error.error?.message || error.message || 'Không xác định';
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: `Có lỗi xảy ra khi cập nhật câu hỏi: ${errorMessage}`,
          life: 3000,
        });
      });
  }

  saveNewQuestion() {
    const trimmedContent = this.newQuestionContent?.trim();
    if (!trimmedContent) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Nội dung câu hỏi không được để trống!',
        life: 3000,
      });
      return;
    }

    const trimmedExplain = this.newExplain?.trim();
    if (!trimmedExplain) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Giải thích không được để trống!',
        life: 3000,
      });
      return;
    }

    for (let i = 0; i < this.newAnswers.length; i++) {
      const trimmedAnswer = this.newAnswers[i].content?.trim();
      if (!trimmedAnswer) {
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: `Nội dung câu trả lời thứ ${i + 1} không được để trống!`,
          life: 3000,
        });
        return;
      }
    }

    if (this.newAnswers.length < 2) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Câu hỏi phải có ít nhất 2 câu trả lời!',
        life: 3000,
      });
      return;
    }

    const correctAnswerCount = this.newAnswers.filter(
      (answer) => answer.correct
    ).length;
    console.log('New Answers before save:', this.newAnswers); // Debug
    if (correctAnswerCount !== 1) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Câu hỏi phải có chính xác một câu trả lời đúng!',
        life: 3000,
      });
      return;
    }

    const questionData = {
      content: trimmedContent,
      failed: this.newFailed,
      explain: trimmedExplain,
      answers: this.newAnswers.map((answer) => ({
        content: answer.content.trim(),
        correct: answer.correct, // Sử dụng 'correct' thay vì 'isCorrect'
        status: answer.status,
      })),
      status: true,
      rankA: this.newFailed,
      isFailed: this.newFailed,
    };
    console.log('Question Data sent to backend:', questionData); // Debug

    const formData = new FormData();
    formData.append('question', JSON.stringify(questionData));
    if (this.newImageFile) {
      formData.append('image', this.newImageFile);
    }
    console.log('FormData before sending:', formData); // Debug

    this.questionService
      .addQuestion(questionData, this.newImageFile)
      .then((res) => {
        console.log('Thêm câu hỏi thành công:', res);
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: 'Thêm câu hỏi thành công!',
          life: 3000,
        });
        const modalElement = document.getElementById('addQuestionModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }
        this.resetAddForm();
        this.findAll();
      })
      .catch((error) => {
        console.error('Lỗi khi thêm câu hỏi:', error);
        const errorMessage =
          error.error?.message || error.message || 'Không xác định';
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: `Có lỗi xảy ra khi thêm câu hỏi: ${errorMessage}`,
          life: 3000,
        });
      });
  }

  fetchQuestionById(id: number, callback: (res: any) => void) {
    this.questionService
      .findById(id)
      .then((res) => {
        if (res.image) {
          res.imageUrl = `${this.baseUrlService.getImageUrl()}/${
            res.image
          }?t=${Date.now()}`;
        } else {
          res.imageUrl = null;
        }
        callback(res);
      })
      .catch((error) => {
        console.error('Lỗi khi lấy dữ liệu câu hỏi:', error);
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail:
            'Không thể tải dữ liệu câu hỏi: ' +
            (error.message || 'Không xác định'),
          life: 3000,
        });
      });
  }

  openEditQuestion(id: number) {
   
    this.fetchQuestionById(id, (res) => {
      console.log('Dữ liệu câu hỏi để chỉnh sửa:', res);
      this.isEditMode = true;
      this.currentQuestionId = id;
      this.originalQuestion = res;
      this.questionContent = res.content;
      this.failed = res.failed;
      this.explain = res.explain;
      this.imageUrl = res.image
        ? `${this.baseUrlService.getImageUrl()}/${res.image}?t=${Date.now()}`
        : null;
      this.originalImage = res.image;
      this.imageFile = null;
      this.answers = res.answers.map((answer: any) => ({
        id: answer.id,
        content: answer.content,
        correct: answer.correct,
        status: answer.status,
      }));
      const modalElement = document.getElementById('questionModal');
      if (modalElement) {
        const modal = new (window as any).bootstrap.Modal(modalElement);
        modal.show();
      }
    });
  }

  openAddQuestionModal() {
    this.resetAddForm();
    this.addNewAnswerField();
    this.addNewAnswerField();
    const modalElement = document.getElementById('addQuestionModal');
    if (modalElement) {
      const modal = new (window as any).bootstrap.Modal(modalElement);
      modal.show();
    }
  }

  searchQuestion(evt: any) {
    const keyWord = evt.target.value.toLowerCase().trim();
    if (keyWord === '') {
      this.findAll();
    } else {
      this.listQuestionOriginal = this.listQuestionOriginal.filter(
        (question: any) => {
          const content = question.content?.toLowerCase() || '';
          return content.includes(keyWord);
        }
      );
      this.totalEntries = this.listQuestionOriginal.length;
      this.currentPage = 1;
      this.updatePaginatedList();
    }
  }

  questionDetails(id: any) {
    this.fetchQuestionById(id, (res) => {
      console.log('Chi tiết câu hỏi:', res);
      this.questionDetail = res;
    });
  }

  deleteQuestion(id: number) {
    console.log('Xóa câu hỏi với ID:', id);
    this.confirmationService.confirm({
      message: 'Bạn có chắc chắn muốn đánh dấu câu hỏi này không khả dụng?',
      header: 'Xác nhận xóa',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Xóa',
      rejectLabel: 'Hủy',
      accept: () => {
        this.questionService
          .delete(id)
          .then((res: any) => {
            if (res.status === 'success') {
              this.messageService.add({
                severity: 'success',
                summary: 'Thành công',
                detail: 'Câu hỏi đã được đánh dấu không khả dụng!',
                life: 3000,
              });
            } else {
              this.messageService.add({
                severity: 'error',
                summary: 'Lỗi',
                detail: res.message || 'Không xác định',
                life: 3000,
              });
            }
            this.findAll();
          })
          .catch((error: any) => {
            console.error('Lỗi khi xóa câu hỏi:', error);
            this.messageService.add({
              severity: 'error',
              summary: 'Lỗi',
              detail:
                'Có lỗi xảy ra khi xóa câu hỏi: ' +
                (error.message || 'Không xác định'),
              life: 3000,
            });
            this.findAll();
          });
      },
      reject: () => {
        this.messageService.add({
          severity: 'info',
          summary: 'Hủy bỏ',
          detail: 'Thao tác xóa đã bị hủy.',
          life: 3000,
        });
      },
    });
  }
}
