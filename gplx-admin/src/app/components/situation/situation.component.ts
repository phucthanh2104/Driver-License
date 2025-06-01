import { Component, OnInit } from '@angular/core';
import { RankService } from 'src/app/service/rank.service';
import { TestService } from 'src/app/service/test.service';

@Component({
  selector: 'app-root',
  templateUrl: './situation.component.html',
  styleUrls: ['./situation.component.css'],
})
export class SituationComponent implements OnInit {
  questionList = [
    { id: 1, title: 'Câu hỏi 1' },
    { id: 2, title: 'Câu hỏi 2' },
    { id: 3, title: 'Câu hỏi 3' },
    { id: 4, title: 'Câu hỏi 4' },
    { id: 5, title: 'Câu hỏi 5' },
  ];
  listTest: any = {};
  listTestOfRank: any = [];
  listRank: any = {};
  listTestOriginal: any[] = [];

  numbers: any;

  selectedQuestions: { id: number; title: string }[] = [];
  selectedLabels: string[] = [];
  newLabel: string = '';
  testTitle: string = '';
  testDescription: string = '';
  testTime: number | null = null;
  testType: string = '';
  searchTerm: string = '';

  constructor(
    private testService: TestService,
    private rankService: RankService
  ) {}

  ngOnInit(): void {
    this.findAll();
    this.findListRank();
  }

  findAll() {
    this.testService.findAllSimulator().then((res) => {
      console.log(res);
      this.listTestOriginal = res;
      this.listTest = [...this.listTestOriginal];
    });
  }

  findTest(evt: any) {
    const rankId = evt.target.value;
    console.log('Rank ID:', rankId);

    if (rankId === '-1') {
      // Nếu chọn "Tất cả", khôi phục danh sách gốc
      this.listTest = [...this.listTestOriginal];
    } else {
      // Gọi API để lấy danh sách đề thi theo rankId
      this.rankService
        .findSimulatorById(rankId)
        .then((res) => {
          this.listTest = res; // Cập nhật danh sách đề thi từ phản hồi API
        })
        .catch((error) => {
          console.error('Lỗi khi lấy danh sách đề thi:', error);
          this.listTest = []; // Xử lý lỗi bằng cách đặt danh sách rỗng
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

      // Kiểm tra nếu không có số trong tìm kiếm, tìm trong cả title và description
      if (!searchNumber) {
        return (
          testTitle.includes(searchTerm) || testDescription.includes(searchTerm)
        );
      }

      // Kiểm tra nếu có số, tìm trong title với từ khóa "đề" và số khớp
      if (searchNumber && testNumber) {
        return (
          (testNumber === searchNumber && testTitle.includes('đề')) ||
          testDescription.includes(searchTerm)
        );
      }

      return false;
    });
  }

  // Thêm câu hỏi vào bảng bên phải và xóa câu hỏi khỏi bảng bên trái
  addQuestionToTest(question: { id: number; title: string }) {
    if (!this.selectedQuestions.includes(question)) {
      this.selectedQuestions.push(question);
      const index = this.questionList.indexOf(question);
      if (index > -1) {
        this.questionList.splice(index, 1);
      }
    }
  }

  // Xóa câu hỏi khỏi bảng bên phải và thêm lại vào bảng bên trái
  removeQuestionFromTest(question: { id: number; title: string }) {
    const index = this.selectedQuestions.indexOf(question);
    if (index > -1) {
      this.selectedQuestions.splice(index, 1);
      this.questionList.push(question);
    }
  }

  // Thêm nhãn vào danh sách đã chọn
  addLabelToTest() {
    if (this.newLabel && !this.selectedLabels.includes(this.newLabel)) {
      this.selectedLabels.push(this.newLabel);
      this.newLabel = ''; // Reset ô nhập nhãn
    }
  }

  // Xóa nhãn khỏi danh sách đã chọn
  removeLabelFromTest(label: string) {
    this.selectedLabels = this.selectedLabels.filter((l) => l !== label);
  }

  // Lưu bộ đề
  saveTest() {
    const testData = {
      title: this.testTitle,
      description: this.testDescription,
      time: this.testTime,
      type: this.testType,
      questions: this.selectedQuestions,
      labels: this.selectedLabels,
    };
    console.log('Dữ liệu bộ đề:', testData);
    this.resetTestForm();
  }

  // Reset form sau khi lưu
  resetTestForm() {
    this.testTitle = '';
    this.testDescription = '';
    this.testTime = null;
    this.testType = '';
    this.selectedQuestions = [];
    this.selectedLabels = [];
    this.newLabel = '';
    // Khôi phục lại danh sách câu hỏi ban đầu nếu cần
    this.questionList = [
      { id: 1, title: 'Câu hỏi 1' },
      { id: 2, title: 'Câu hỏi 2' },
      { id: 3, title: 'Câu hỏi 3' },
      { id: 4, title: 'Câu hỏi 4' },
      { id: 5, title: 'Câu hỏi 5' },
    ];
  }
}