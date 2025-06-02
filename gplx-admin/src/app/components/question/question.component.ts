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

  // Pagination properties
  currentPage: number = 1;
  pageSize: number = 10;
  totalEntries: number = 0;
  pageSizes: number[] = [10, 25, 50, 100];

  ngOnInit(): void {
    this.findAll();
  }

  findAll() {
    this.questionService
      .findAll()
      .then((res) => {
        console.log('Danh sách câu hỏi:', res);
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
    this.currentPage = 1; // Reset về trang đầu tiên
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
    if (imageInput) {
      imageInput.value = '';
    }
  }

  addAnswerField() {
    this.answers.push({ content: '', correct: false, status: true });
  }

  removeAnswerField(index: number) {
    this.answers.splice(index, 1);
  }

  resetForm() {
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
    if (imageInput) {
      imageInput.value = '';
    }
  }

  onAnswerCorrectChange(selectedIndex: number) {
    // Đặt tất cả các câu trả lời khác thành correct: false
    this.answers = this.answers.map((answer, index) => ({
      ...answer,
      correct: index === selectedIndex,
    }));
  }

  saveQuestion() {
    // Kiểm tra nội dung câu hỏi không được để trống
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

    // Kiểm tra giải thích không được để trống
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

    // Kiểm tra nội dung câu trả lời không được để trống hoặc chỉ chứa khoảng trắng
    for (let i = 0; i < this.answers.length; i++) {
      const answer = this.answers[i];
      const trimmedAnswer = answer.content?.trim();
      if (!trimmedAnswer) {
        // Nếu để trống, sử dụng giá trị gốc nếu có
        const originalAnswer = this.originalQuestion?.answers.find(
          (a: any) => a.id === answer.id
        );
        if (originalAnswer?.content) {
          answer.content = originalAnswer.content;
        } else {
          this.messageService.add({
            severity: 'error',
            summary: 'Lỗi',
            detail: `Nội dung câu trả lời thứ ${i + 1} không được để trống!`,
            life: 3000,
          });
          return;
        }
      }
    }

    // Kiểm tra phải có ít nhất 2 câu trả lời
    if (this.answers.length < 2) {
      this.messageService.add({
        severity: 'error',
        summary: 'Lỗi',
        detail: 'Câu hỏi phải có ít nhất 2 câu trả lời!',
        life: 3000,
      });
      return;
    }

    // Kiểm tra phải có chính xác một câu trả lời đúng
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

    // Tạo dữ liệu câu hỏi để gửi lên backend
    const questionData = {
      id: this.currentQuestionId,
      content: trimmedContent || this.originalQuestion?.content || '',
      failed: this.failed,
      explain: trimmedExplain || this.originalQuestion?.explain || '',
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

    const action = this.isEditMode
      ? this.questionService.update(
          this.currentQuestionId!,
          questionData,
          this.imageFile
        )
      : this.questionService.addQuestion(questionData, this.imageFile);

    action
      .then((res) => {
        console.log(
          `${this.isEditMode ? 'Cập nhật' : 'Thêm'} câu hỏi thành công:`,
          res
        );
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: `${
            this.isEditMode ? 'Cập nhật' : 'Thêm'
          } câu hỏi thành công!`,
          life: 3000,
        });

        const modalElement = document.getElementById('questionModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }

        this.resetForm();
        this.findAll();
      })
      .catch((error) => {
        console.error(
          `Lỗi khi ${this.isEditMode ? 'cập nhật' : 'thêm'} câu hỏi:`,
          error
        );
        const errorMessage =
          error.error?.message || error.message || 'Không xác định';
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: `Có lỗi xảy ra khi ${
            this.isEditMode ? 'cập nhật' : 'thêm'
          } câu hỏi: ${errorMessage}`,
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

      // Điền dữ liệu vào các field
      this.questionContent = res.content;
      this.failed = res.failed;
      this.explain = res.explain;
      this.imageUrl = res.image
        ? `${this.baseUrlService.getImageUrl()}/${res.image}?t=${Date.now()}`
        : null;
      this.originalImage = res.image;
      this.imageFile = null;

      // Điền danh sách câu trả lời
      this.answers = res.answers.map((answer: any) => ({
        id: answer.id,
        content: answer.content,
        correct: answer.correct, // Đảm bảo ánh xạ đúng từ backend
        status: answer.status,
      }));

      // Mở modal
      const modalElement = document.getElementById('questionModal');
      if (modalElement) {
        const modal = new (window as any).bootstrap.Modal(modalElement);
        modal.show();
      }
    });
  }

  searchQuestion(evt: any) {
    const keyWord = evt.target.value.toLowerCase().trim();
    if (keyWord === '') {
      this.listQuestionOriginal = [...this.listQuestionOriginal];
    } else {
      this.listQuestionOriginal = this.listQuestionOriginal.filter(
        (question: any) => {
          const content = question.content?.toLowerCase() || '';
          return content.includes(keyWord);
        }
      );
    }
    this.currentPage = 1; // Reset về trang đầu tiên
    this.updatePaginatedList();
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
          })
          .finally(() => {
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
        this.findAll();
      },
    });
  }

  openAddQuestionModal() {
    this.isEditMode = false;
    this.resetForm();
    const modalElement = document.getElementById('questionModal');
    if (modalElement) {
      const modal = new (window as any).bootstrap.Modal(modalElement);
      modal.show();
    }
  }

  goToQuestion() {
    window.location.href = '/question';
  }
}
