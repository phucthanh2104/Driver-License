import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { QuestionService } from 'src/app/service/question.service';
import { RankService } from 'src/app/service/rank.service';
import { TestService } from 'src/app/service/test.service';

@Component({
  selector: 'app-root',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.css'],
})
export class TestComponent implements OnInit {
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

  constructor(
    private testService: TestService,
    private rankService: RankService,
    private questionService: QuestionService,
    private cdr: ChangeDetectorRef // Thêm ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.findAll();
    this.findListRank();
    this.findAllQuestion();
  }

  findAllQuestion() {
    this.questionService.findAll().then((res) => {
      console.log('Question List:', res);
      this.questionList = res;
      this.filteredQuestions = [...this.questionList];
      this.cdr.detectChanges(); // Cập nhật giao diện
    });
  }

  filterQuestions() {
    console.log('Search Term:', this.searchTerm);
    console.log('Question List:', this.questionList);

    if (!this.searchTerm) {
      this.filteredQuestions = [...this.questionList];
      console.log('Filtered Questions (empty search):', this.filteredQuestions);
    } else {
      const searchTermLower = this.searchTerm.toLowerCase().trim();

      this.filteredQuestions = this.questionList
        .filter((question) => {
          const content = question.content?.toLowerCase() || '';
          const id = question.id?.toString() || '';
          const contentMatch = content.includes(searchTermLower);
          const idMatch = id.includes(searchTermLower);
          console.log(
            `Question ID: ${question.id}, Content: ${content}, Content Match: ${contentMatch}, ID Match: ${idMatch}`
          );
          return contentMatch || idMatch;
        })
        .sort((a, b) => {
          const contentA = a.content?.toLowerCase() || '';
          const contentB = b.content?.toLowerCase() || '';
          const startsWithA = contentA.startsWith(searchTermLower);
          const startsWithB = contentB.startsWith(searchTermLower);
          if (startsWithA && !startsWithB) return -1;
          if (!startsWithA && startsWithB) return 1;
          return 0;
        });

      console.log('Filtered Questions:', this.filteredQuestions);
    }

    this.cdr.detectChanges(); // Ép cập nhật giao diện
  }

  // Các phương thức khác giữ nguyên, chỉ thêm cdr.detectChanges() nếu cần
  findAll() {
    this.testService.findAllTest().then((res) => {
      console.log('List Test:', res);
      this.listTestOriginal = res;
      this.listTest = [...this.listTestOriginal];
      this.cdr.detectChanges();
    });
  }

  findListRank() {
    this.rankService.findAll().then((res) => {
      this.listRank = res;
      console.log('List Rank:', res);
      this.cdr.detectChanges();
    });
  }

  findTest(evt: any) {
    const rankId = evt.target.value;
    console.log('Rank ID:', rankId);
    if (rankId === '-1') {
      this.listTest = [...this.listTestOriginal];
    } else {
      this.rankService
        .findTestById(rankId)
        .then((res) => {
          console.log('Kết quả từ API:', res);
          this.listTest = res;
          this.cdr.detectChanges();
        })
        .catch((error) => {
          console.error('Lỗi khi lấy danh sách đề thi:', error);
          this.listTest = [];
          this.cdr.detectChanges();
        });
    }
  }

  findTestTitle(evt: any) {
    const searchTerm = evt.target.value.toLowerCase().trim();
    console.log('Từ khóa tìm kiếm:', searchTerm);
    this.listTest = this.listTestOriginal.filter((test) => {
      const testTitle = test.title?.toLowerCase() || '';
      const testDescription = test.description?.toLowerCase() || '';
      const searchNumberMatch = searchTerm.match(/\d+/);
      const searchNumber = searchNumberMatch ? searchNumberMatch[0] : null;
      const testNumberMatch = testTitle.match(/\d+/);
      const testNumber = testNumberMatch ? testNumberMatch[0] : null;
      if (!searchNumber) {
        return (
          testTitle.includes(searchTerm) || testDescription.includes(searchTerm)
        );
      }
      if (searchNumber && testNumber) {
        return (
          (testNumber === searchNumber && testTitle.includes('đề')) ||
          testDescription.includes(searchTerm)
        );
      }
      return false;
    });
    this.cdr.detectChanges();
  }

  addQuestionToTest(question: any) {
    if (!this.selectedQuestions.some((q) => q.id === question.id)) {
      this.selectedQuestions.push(question);
      this.filteredQuestions = this.filteredQuestions.filter(
        (q) => q.id !== question.id
      );
      this.cdr.detectChanges();
    }
  }

  removeQuestionFromTest(question: any) {
    const index = this.selectedQuestions.findIndex((q) => q.id === question.id);
    if (index > -1) {
      this.selectedQuestions.splice(index, 1);
      if (!this.filteredQuestions.some((q) => q.id === question.id)) {
        this.filteredQuestions.push(question);
      }
      this.cdr.detectChanges();
    }
  }

  addLabelToTest() {
    if (this.newLabel && !this.selectedLabels.includes(this.newLabel)) {
      this.selectedLabels.push(this.newLabel);
      this.newLabel = '';
      this.cdr.detectChanges();
    }
  }

  removeLabelFromTest(label: string) {
    this.selectedLabels = this.selectedLabels.filter((l) => l !== label);
    this.cdr.detectChanges();
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
    console.log('Dữ liệu bộ đề:', testData);
    this.testService
      .save(testData)
      .then((response) => {
        console.log('Kết quả lưu:', response);
        alert('Lưu bộ đề thành công!');
        const modalElement = document.getElementById('addTestModal');
        if (modalElement) {
          const modal = (window as any).bootstrap.Modal.getInstance(
            modalElement
          );
          modal.hide();
        }
        this.resetTestForm();
        this.findAll();
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
    this.testType = '';
    this.rankId = null;
    this.selectedQuestions = [];
    this.selectedLabels = [];
    this.newLabel = '';
    this.findAllQuestion();
    this.cdr.detectChanges();
  }

  deleteTest(testId: any) {
    if (confirm('Bạn có chắc chắn muốn xóa bộ đề này?')) {
      this.testService
        .delete(testId)
        .then((response) => {
          console.log('Kết quả xóa:', response);
          alert('Xóa bộ đề thành công!');
          this.findAll();
        })
        .catch((error) => {
          console.error('Lỗi khi xóa bộ đề:', error);
          alert('Có lỗi xảy ra khi xóa bộ đề: ' + error.message);
        });
    }
  }
}
