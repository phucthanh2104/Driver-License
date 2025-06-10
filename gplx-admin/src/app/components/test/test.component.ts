import { Component, OnInit } from '@angular/core';
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
  testType: string = '';
  rankId: number | null = null; // Thêm biến rankId để lưu giá trị từ select
  searchTerm: string = '';
  filteredQuestions: any[] = [];

  constructor(
    private testService: TestService,
    private rankService: RankService,
    private questionService: QuestionService
  ) {}

  ngOnInit(): void {
    this.findAll();
    this.findListRank();
    this.findAllQuestion();
  }

  findAll() {
    this.testService.findAllTest().then((res) => {
      console.log(res);
      this.listTestOriginal = res;
      this.listTest = [...this.listTestOriginal];
    });
  }

  findAllQuestion() {
    this.questionService.findAll().then((res) => {
      console.log(res);
      this.questionList = res;
      this.filteredQuestions = [...this.questionList];
    });
  }

  filterQuestions() {
    if (!this.searchTerm) {
      this.filteredQuestions = [...this.questionList];
      return;
    }
    this.filteredQuestions = this.questionList.filter(
      (question) =>
        question.content
          ?.toLowerCase()
          .includes(this.searchTerm.toLowerCase()) ||
        (question.id?.toString() &&
          question.id.toString().includes(this.searchTerm))
    );
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
        })
        .catch((error) => {
          console.error('Lỗi khi lấy danh sách đề thi:', error);
          this.listTest = [];
        });
    }
  }

  findListRank() {
    this.rankService.findAll().then((res) => {
      this.listRank = res;
      console.log(res);
    });
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
  }

  addQuestionToTest(question: any) {
    if (!this.selectedQuestions.some((q) => q.id === question.id)) {
      this.selectedQuestions.push(question);
      this.filteredQuestions = this.filteredQuestions.filter(
        (q) => q.id !== question.id
      );
    }
  }

  removeQuestionFromTest(question: any) {
    const index = this.selectedQuestions.findIndex((q) => q.id === question.id);
    if (index > -1) {
      this.selectedQuestions.splice(index, 1);
      if (!this.filteredQuestions.some((q) => q.id === question.id)) {
        this.filteredQuestions.push(question);
      }
    }
  }

  addLabelToTest() {
    if (this.newLabel && !this.selectedLabels.includes(this.newLabel)) {
      this.selectedLabels.push(this.newLabel);
      this.newLabel = '';
    }
  }

  removeLabelFromTest(label: string) {
    this.selectedLabels = this.selectedLabels.filter((l) => l !== label);
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
      rank: this.rankId, // Lấy rankId từ giao diện
      isTest: true, // Có thể thay đổi dựa trên logic nếu cần
      numberOfQuestions: this.selectedQuestions.length,
      testDetails: this.selectedQuestions.map((question) => ({
        testId: null,
        chapterId: null,
        question: { id: question.id } ,
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
        this.findAll(); // Làm mới danh sách sau khi lưu
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
    this.findAllQuestion(); // Khôi phục lại danh sách câu hỏi ban đầu
  }
}
