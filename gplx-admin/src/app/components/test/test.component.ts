import {
  Component,
  OnInit,
  AfterViewInit,
  OnDestroy,
  ChangeDetectorRef,
} from '@angular/core';
import { MessageService, ConfirmationService } from 'primeng/api';
import { QuestionService } from 'src/app/service/question.service';
import { RankService } from 'src/app/service/rank.service';
import { TestService } from 'src/app/service/test.service';

declare var $: any;

@Component({
  selector: 'app-root',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.css'],
})
export class TestComponent implements OnInit, AfterViewInit, OnDestroy {
  questionList: any[] = [];
  listTest: any[] = [];
  listTestOfRank: any[] = [];
  listRank: any[] = [];
  listTestOriginal: any[] = [];

  // Properties cho add test
  selectedQuestions: any[] = [];
  selectedLabels: string[] = [];
  newLabel: string = '';
  testTitle: string = '';
  testDescription: string = '';
  testTime: number | null = null;
  passedScore: number | null = null;
  testType: string = '';
  rankId: number | null = null;
  searchTerm: string = '';
  filteredQuestions: any[] = [];

  // Properties cho edit test
  editTestId: number | null = null;
  editTestTitle: string = '';
  editTestDescription: string = '';
  editTestTime: number | null = null;
  editPassedScore: number | null = null;
  editTestType: string = '';
  editRankId: number | null = null;
  editSelectedQuestions: any[] = [];
  editFilteredQuestions: any[] = [];
  editSearchTerm: string = '';

  private dataTable: any;

  constructor(
    private testService: TestService,
    private rankService: RankService,
    private questionService: QuestionService,
    private cdr: ChangeDetectorRef,
    private messageService: MessageService,
    private confirmationService: ConfirmationService
  ) {}

  ngOnInit(): void {
    console.log('Test Component initialized');
    this.findAll();
    this.findListRank();
    this.findAllQuestion();
  }

  ngAfterViewInit(): void {
    setTimeout(() => {
      this.initDataTable();
    }, 200);
  }

  ngOnDestroy(): void {
    try {
      if (this.dataTable) {
        this.dataTable.destroy();
        this.dataTable = null;
      }
    } catch (error) {
      console.log('Error destroying DataTable:', error);
    }
  }

  initDataTable(): void {
    try {
      if ($.fn.DataTable.isDataTable('#basic-datatable')) {
        $('#basic-datatable').DataTable().destroy();
      }

      this.dataTable = $('#basic-datatable').DataTable({
        responsive: true,
        destroy: true,
        language: {
          lengthMenu: 'Hiển thị _MENU_ mục',
          zeroRecords: 'Không tìm thấy dữ liệu',
          info: 'Hiển thị _START_ đến _END_ của _TOTAL_ mục',
          infoEmpty: 'Hiển thị 0 đến 0 của 0 mục',
          infoFiltered: '(lọc từ _MAX_ tổng số mục)',
          search: 'Tìm kiếm:',
          paginate: {
            first: 'Đầu',
            last: 'Cuối',
            next: 'Sau',
            previous: 'Trước',
          },
        },
        pageLength: 10,
        lengthMenu: [
          [10, 25, 50, 100],
          [10, 25, 50, 100],
        ],
      });
      console.log('DataTable initialized successfully');
    } catch (error) {
      console.error('Error initializing DataTable:', error);
    }
  }

  refreshTable(): void {
    this.cdr.detectChanges();
    if (this.dataTable) {
      this.dataTable.draw();
    }
  }

  findAll() {
    this.testService
      .findAllTest()
      .then((res) => {
        console.log('List Test from API:', res);

        // Lọc chỉ những test có status = true
        const activeTests = res.filter((test: any) => test.status === true);

        this.listTestOriginal = activeTests;
        this.listTest = [...this.listTestOriginal];

        this.cdr.detectChanges();

        console.log('Filtered active tests:', this.listTest);
      })
      .catch((error) => {
        console.error('Lỗi khi lấy danh sách test:', error);
        this.listTest = [];
        this.listTestOriginal = [];
        this.cdr.detectChanges();
      });
  }

  findListRank() {
    this.rankService.findAll().then((res) => {
      this.listRank = res;
      this.cdr.detectChanges();
    });
  }

  findAllQuestion() {
    this.questionService.findAll().then((res) => {
      this.questionList = res;
      this.filteredQuestions = [...this.questionList];
      this.editFilteredQuestions = [...this.questionList];
      this.cdr.detectChanges();
    });
  }

  findTest(evt: any) {
    const rankId = evt.target.value;
    console.log('Rank ID selected:', rankId);

    if (rankId === '-1') {
      this.listTest = [...this.listTestOriginal];
      console.log('Showing all active tests:', this.listTest);
      this.cdr.detectChanges();
    } else {
      this.rankService
        .findTestById(rankId)
        .then((res) => {
          console.log('API response for rank:', res);

          const activeTests = res.filter((test: any) => test.status === true);
          console.log('Active tests for rank:', activeTests);

          this.listTest = activeTests;
          this.cdr.detectChanges();
        })
        .catch((error) => {
          console.error('Lỗi khi lấy danh sách đề thi theo rank:', error);
          this.listTest = [];
          console.log('No tests found for rank, setting empty list');
          this.cdr.detectChanges();
        });
    }
  }

  // Methods cho Add Test
  filterQuestions() {
    if (!this.searchTerm || this.searchTerm.trim() === '') {
      this.filteredQuestions = this.questionList.filter(
        (question) =>
          !this.selectedQuestions.some(
            (selected) => selected.id === question.id
          )
      );
    } else {
      const searchTermLower = this.searchTerm.toLowerCase().trim();
      this.filteredQuestions = this.questionList.filter((question) => {
        const isAlreadySelected = this.selectedQuestions.some(
          (selected) => selected.id === question.id
        );
        if (isAlreadySelected) return false;

        const content = question.content?.toLowerCase() || '';
        const id = question.id?.toString() || '';
        return (
          content.includes(searchTermLower) || id.includes(searchTermLower)
        );
      });
    }
    this.cdr.detectChanges();
  }

  onSearchQuestions(event: any) {
    this.searchTerm = event.target.value;
    this.filterQuestions();
  }

  addQuestionToTest(question: any) {
    if (!this.selectedQuestions.some((q) => q.id === question.id)) {
      this.selectedQuestions.push(question);
      this.filterQuestions();
    }
  }

  removeQuestionFromTest(question: any) {
    const index = this.selectedQuestions.findIndex((q) => q.id === question.id);
    if (index > -1) {
      this.selectedQuestions.splice(index, 1);
      this.filterQuestions();
    }
  }

  saveTest() {
    // Validation với MessageService
    if (
      !this.testTitle ||
      !this.testTime ||
      this.testType === '-1' ||
      !this.passedScore ||
      !this.rankId ||
      this.rankId === -1
    ) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Cảnh báo',
        detail:
          'Vui lòng điền đầy đủ thông tin tiêu đề, thời gian, loại, điểm đậu và hạng!',
      });
      return;
    }

    if (this.selectedQuestions.length === 0) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Cảnh báo',
        detail: 'Vui lòng chọn ít nhất một câu hỏi!',
      });
      return;
    }

    const testData: any = {
      title: this.testTitle,
      description: this.testDescription,
      time: this.testTime,
      type: this.testType,
      status: true,
      passedScore: this.passedScore || 0,
      rank: this.rankId,
      isTest: true,
      numberOfQuestions: this.selectedQuestions.length,
      testDetails: this.selectedQuestions.map((question) => ({
        testId: null,
        chapterId: null,
        question: { id: question.id },
        status: true,
      })),
    };

    this.testService
      .save(testData)
      .then((response) => {
        console.log('Kết quả lưu:', response);

        // Hiển thị toast thành công
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: 'Lưu bộ đề thành công!',
        });

        // Đóng modal
        const modalElement = document.getElementById('addTestModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }

        this.resetTestForm();

        // Thêm test mới vào list thay vì reload toàn bộ
        this.addNewTestToList(response);
      })
      .catch((error) => {
        console.error('Lỗi khi lưu bộ đề:', error);

        // Hiển thị toast lỗi
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail: 'Có lỗi xảy ra khi lưu bộ đề: ' + error.message,
        });
      });
  }

  // Methods cho Edit Test
  editTest(test: any) {
    // Set thông tin cơ bản
    this.editTestId = test.id;
    this.editTestTitle = test.title;
    this.editTestDescription = test.description || '';
    this.editTestTime = test.time;
    this.editPassedScore = test.passedScore;
    this.editTestType = test.type?.toString() || '';

    // Lấy rank ID
    if (test.rank && typeof test.rank === 'object') {
      this.editRankId = test.rank.id;
    } else {
      this.editRankId = test.rank;
    }

    // Load câu hỏi đã chọn từ testDetails
    if (test.testDetails && test.testDetails.length > 0) {
      this.editSelectedQuestions = test.testDetails
        .filter((detail: any) => detail.status && detail.question)
        .map((detail: any) => detail.question);
    } else {
      this.editSelectedQuestions = [];
    }

    // Filter danh sách câu hỏi
    this.filterEditQuestions();

    // Mở modal
    const modalElement = document.getElementById('editTestModal');
    if (modalElement) {
      const modal = new (window as any).bootstrap.Modal(modalElement);
      modal.show();
    }
  }

  filterEditQuestions() {
    if (!this.editSearchTerm || this.editSearchTerm.trim() === '') {
      this.editFilteredQuestions = this.questionList.filter(
        (question) =>
          !this.editSelectedQuestions.some(
            (selected) => selected.id === question.id
          )
      );
    } else {
      const searchTermLower = this.editSearchTerm.toLowerCase().trim();
      this.editFilteredQuestions = this.questionList.filter((question) => {
        const isAlreadySelected = this.editSelectedQuestions.some(
          (selected) => selected.id === question.id
        );
        if (isAlreadySelected) return false;

        const content = question.content?.toLowerCase() || '';
        const id = question.id?.toString() || '';
        return (
          content.includes(searchTermLower) || id.includes(searchTermLower)
        );
      });
    }
    this.cdr.detectChanges();
  }

  onEditSearchQuestions(event: any) {
    this.editSearchTerm = event.target.value;
    this.filterEditQuestions();
  }

  addQuestionToEditTest(question: any) {
    if (!this.editSelectedQuestions.some((q) => q.id === question.id)) {
      this.editSelectedQuestions.push(question);
      this.filterEditQuestions();
    }
  }

  removeQuestionFromEditTest(question: any) {
    const index = this.editSelectedQuestions.findIndex(
      (q) => q.id === question.id
    );
    if (index > -1) {
      this.editSelectedQuestions.splice(index, 1);
      this.filterEditQuestions();
    }
  }

  updateTest() {
    // Validation
    if (
      !this.editTestTitle ||
      !this.editTestTime ||
      this.editTestType === '-1' ||
      !this.editPassedScore ||
      !this.editRankId ||
      this.editRankId === -1
    ) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Cảnh báo',
        detail:
          'Vui lòng điền đầy đủ thông tin tiêu đề, thời gian, loại, điểm đậu và hạng!',
      });
      return;
    }

    if (this.editSelectedQuestions.length === 0) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Cảnh báo',
        detail: 'Vui lòng chọn ít nhất một câu hỏi!',
      });
      return;
    }

    const updateData: any = {
      id: this.editTestId,
      title: this.editTestTitle,
      description: this.editTestDescription,
      type: this.editTestType,
      time: this.editTestTime,
      passedScore: this.editPassedScore || 0,
      status: true,
      numberOfQuestions: this.editSelectedQuestions.length,
      rank: this.editRankId,
      testDetails: this.editSelectedQuestions.map((question) => ({
        question: { id: question.id },
        status: true,
      })),
    };

    this.testService
      .updateTest(updateData)
      .then((response) => {
        console.log('Kết quả cập nhật:', response);

        // Hiển thị toast thành công
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: 'Cập nhật bộ đề thành công!',
        });

        // Đóng modal
        const modalElement = document.getElementById('editTestModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }

        // Tạo object test đã cập nhật với thông tin đầy đủ
        const updatedTest = {
          id: this.editTestId,
          title: this.editTestTitle,
          description: this.editTestDescription,
          type: parseInt(this.editTestType),
          time: this.editTestTime,
          passedScore: this.editPassedScore,
          status: true,
          numberOfQuestions: this.editSelectedQuestions.length,
          rank: this.getRankObject(this.editRankId),
          testDetails: this.editSelectedQuestions.map((question) => ({
            question: question,
            status: true,
          })),
        };

        // Reset form
        this.resetEditForm();

        // Cập nhật list ngay lập tức
        this.updateListAfterEdit(updatedTest);
      })
      .catch((error) => {
        console.error('Lỗi khi cập nhật bộ đề:', error);

        // Hiển thị toast lỗi
        this.messageService.add({
          severity: 'error',
          summary: 'Lỗi',
          detail:
            'Có lỗi xảy ra khi cập nhật bộ đề: ' +
            (error.message || 'Lỗi không xác định'),
        });
      });
  }

  getRankObject(rankId: any) {
    const rank = this.listRank.find((r) => r.id == rankId);
    return rank || { id: rankId, name: `Hạng ${rankId}` };
  }
  resetEditForm() {
    this.editTestId = null;
    this.editTestTitle = '';
    this.editTestDescription = '';
    this.editTestTime = null;
    this.editPassedScore = null;
    this.editTestType = '';
    this.editRankId = null;
    this.editSelectedQuestions = [];
    this.editSearchTerm = '';
    this.editFilteredQuestions = [...this.questionList];
    this.cdr.detectChanges();
  }

  updateListAfterEdit(updatedTest: any) {
    // Cập nhật trong listTestOriginal
    const originalIndex = this.listTestOriginal.findIndex(
      (test) => test.id === updatedTest.id
    );
    if (originalIndex > -1) {
      this.listTestOriginal[originalIndex] = updatedTest;
    }

    // Cập nhật trong listTest hiện tại
    const currentIndex = this.listTest.findIndex(
      (test) => test.id === updatedTest.id
    );
    if (currentIndex > -1) {
      this.listTest[currentIndex] = updatedTest;
    }

    this.cdr.detectChanges();
    console.log('List updated after edit:', this.listTest);
  }

  // Hàm thêm test mới vào list
  addNewTestToList(newTest: any) {
    // Thêm vào đầu list
    this.listTestOriginal.unshift(newTest);
    this.listTest.unshift(newTest);

    // Cập nhật giao diện
    this.cdr.detectChanges();

    console.log('New test added to list:', newTest);
  }

  resetTestForm() {
    this.testTitle = '';
    this.testDescription = '';
    this.testTime = null;
    this.passedScore = null;
    this.testType = '';
    this.rankId = null;
    this.selectedQuestions = [];
    this.selectedLabels = [];
    this.newLabel = '';
    this.searchTerm = '';
    this.filteredQuestions = [...this.questionList];
    this.cdr.detectChanges();
  }

  deleteTest(testId: any) {
    // Sử dụng ConfirmationService thay vì confirm()
    this.confirmationService.confirm({
      message: 'Bạn có chắc chắn muốn xóa bộ đề này?',
      header: 'Xác nhận xóa',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
        this.testService
          .delete(testId)
          .then((response) => {
            console.log('Kết quả xóa:', response);

            // Hiển thị toast thành công
            this.messageService.add({
              severity: 'success',
              summary: 'Thành công',
              detail: 'Xóa bộ đề thành công!',
            });

            // Tự động cập nhật listTest mà không cần reload toàn bộ
            this.updateListAfterDelete(testId);
          })
          .catch((error) => {
            console.error('Lỗi khi xóa bộ đề:', error);

            // Hiển thị toast lỗi
            this.messageService.add({
              severity: 'error',
              summary: 'Lỗi',
              detail: 'Có lỗi xảy ra khi xóa bộ đề: ' + error.message,
            });
          });
      },
      reject: () => {
        // User cancelled - không cần làm gì
      },
    });
  }

  // Hàm cập nhật list sau khi xóa
  updateListAfterDelete(deletedTestId: any) {
    // Xóa test khỏi listTestOriginal
    this.listTestOriginal = this.listTestOriginal.filter(
      (test) => test.id !== deletedTestId
    );

    // Xóa test khỏi listTest hiện tại
    this.listTest = this.listTest.filter((test) => test.id !== deletedTestId);

    // Cập nhật giao diện
    this.cdr.detectChanges();

    console.log('List updated after delete:', this.listTest);
  }
  getRankNameById(rankId: any): string {
    if (!rankId) return 'Không xác định';

    const rank = this.listRank.find((r) => r.id === rankId);
    return rank ? rank.name : `Hạng ${rankId}`;
  }
}
