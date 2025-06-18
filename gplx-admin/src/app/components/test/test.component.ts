import {
  Component,
  OnInit,
  AfterViewInit,
  OnDestroy,
  ChangeDetectorRef,
} from '@angular/core';
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

  private dataTable: any;

  constructor(
    private testService: TestService,
    private rankService: RankService,
    private questionService: QuestionService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    console.log('Test Component initialized');
    this.findAll();
    this.findListRank();
    this.findAllQuestion();
  }

  ngAfterViewInit(): void {
    // Đợi một chút để DOM render xong rồi mới khởi tạo DataTable
    setTimeout(() => {
      this.initDataTable();
    }, 200);
  }

  ngOnDestroy(): void {
    // Destroy DataTable khi component bị hủy
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
      // Kiểm tra nếu DataTable đã được khởi tạo thì destroy trước
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

  // XÓA hàm reloadDataTable() - không cần thiết
  refreshTable(): void {
    this.cdr.detectChanges();
    // DataTable sẽ tự động cập nhật từ DOM
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

        // Chỉ cần detectChanges, DataTable sẽ tự cập nhật
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
      this.cdr.detectChanges();
    });
  }

  // Lọc test theo rank
  findTest(evt: any) {
    const rankId = evt.target.value;
    console.log('Rank ID selected:', rankId);

    if (rankId === '-1') {
      // Nếu chọn "Tất cả", hiển thị tất cả test có status = true
      this.listTest = [...this.listTestOriginal];
      console.log('Showing all active tests:', this.listTest);
      this.cdr.detectChanges();
    } else {
      this.rankService
        .findTestById(rankId)
        .then((res) => {
          console.log('API response for rank:', res);

          // Lọc chỉ những test có status = true
          const activeTests = res.filter((test: any) => test.status === true);
          console.log('Active tests for rank:', activeTests);

          this.listTest = activeTests;
          this.cdr.detectChanges();
        })
        .catch((error) => {
          console.error('Lỗi khi lấy danh sách đề thi theo rank:', error);
          // Đặt danh sách rỗng khi không có test hoặc có lỗi
          this.listTest = [];
          console.log('No tests found for rank, setting empty list');
          this.cdr.detectChanges();
        });
    }
  }

  // Các hàm cho modal thêm test
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
    if (
      !this.testTitle ||
      !this.testTime ||
      this.testType === '-1' ||
      !this.rankId ||
      this.rankId === -1
    ) {
      alert('Vui lòng điền đầy đủ thông tin tiêu đề, thời gian, loại và hạng!');
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
        alert('Lưu bộ đề thành công!');

        // Đóng modal
        const modalElement = document.getElementById('addTestModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }

        this.resetTestForm();
        this.findAll(); // Reload dữ liệu
      })
      .catch((error) => {
        console.error('Lỗi khi lưu bộ đề:', error);
        alert('Có lỗi xảy ra khi lưu bộ đề: ' + error.message);
      });
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
    if (confirm('Bạn có chắc chắn muốn xóa bộ đề này?')) {
      this.testService
        .delete(testId)
        .then((response) => {
          console.log('Kết quả xóa:', response);
          alert('Xóa bộ đề thành công!');
          this.findAll(); // Reload dữ liệu
        })
        .catch((error) => {
          console.error('Lỗi khi xóa bộ đề:', error);
          alert('Có lỗi xảy ra khi xóa bộ đề: ' + error.message);
        });
    }
  }
}
