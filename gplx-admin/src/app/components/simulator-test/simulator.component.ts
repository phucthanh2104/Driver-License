import {
  Component,
  OnInit,
  AfterViewInit,
  OnDestroy,
  ChangeDetectorRef,
} from '@angular/core';
import { MessageService, ConfirmationService } from 'primeng/api';
import { RankService } from 'src/app/service/rank.service';
import { SimualtorService } from 'src/app/service/simulator.service';
import { TestService } from 'src/app/service/test.service';

declare var $: any;

@Component({
  selector: 'app-root',
  templateUrl: './simulator.component.html',
  styleUrls: ['./simulator.component.css'],
})
export class SimulatorComponent implements OnInit, AfterViewInit, OnDestroy {
  simulatorList: any[] = [];
  listTest: any[] = [];
  listTestOfRank: any[] = [];
  listRank: any[] = [];
  listTestOriginal: any[] = [];

  selectedSimulators: any[] = [];
  testTitle: string = '';
  testDescription: string = '';
  testTime: number | null = null;
  passedScore: number | null = null;
  testType: string = '';
  rankId: number | null = null;
  searchTerm: string = '';
  filteredSimulators: any[] = [];

  // Properties cho edit test
  editTestId: number | null = null;
  editTestTitle: string = '';
  editTestDescription: string = '';
  editTestTime: number | null = null;
  editPassedScore: number | null = null;
  editTestType: string = '';
  editRankId: number | null = null;
  editSelectedSimulators: any[] = [];
  editFilteredSimulators: any[] = [];
  editSearchTerm: string = '';

  private dataTable: any;

  constructor(
    private testService: TestService,
    private rankService: RankService,
    private simulatorService: SimualtorService,
    private cdr: ChangeDetectorRef,
    private messageService: MessageService,
    private confirmationService: ConfirmationService
  ) {}

  ngOnInit(): void {
    // Load rank trước, sau đó mới load tests
    this.findListRank().then(() => {
      this.findAll();
      this.findAllSimulators();
    });
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

  findAll() {
    this.testService
      .findAllSimulator()
      .then((res) => {
        console.log('List Simulator Tests from API:', res);

        // Lọc chỉ những test có status = true
        const activeTests = res.filter((test: any) => test.status === true);

        // Map rank.name vào test.rank
        const testsWithRankName = activeTests.map((test: any) => {
          if (test.rank && typeof test.rank === 'number') {
            // Nếu test.rank là number (ID), tìm rank tương ứng
            const foundRank = this.listRank.find(
              (rank: any) => rank.id === test.rank
            );
            if (foundRank) {
              test.rank = {
                id: foundRank.id,
                name: foundRank.name,
              };
            }
          } else if (test.rank && test.rank.id) {
            // Nếu test.rank đã là object có ID, tìm và gán name
            const foundRank = this.listRank.find(
              (rank: any) => rank.id === test.rank.id
            );
            if (foundRank) {
              test.rank.name = foundRank.name;
            }
          }
          return test;
        });

        this.listTestOriginal = testsWithRankName;
        this.listTest = [...this.listTestOriginal];
        this.cdr.detectChanges();

        console.log('Active tests with rank names:', this.listTest);
      })
      .catch((error) => {
        console.error('Lỗi khi lấy danh sách simulator tests:', error);
        this.listTest = [];
        this.listTestOriginal = [];
        this.cdr.detectChanges();
      });
  }

  findListRank() {
    return this.rankService.findAll().then((res) => {
      this.listRank = res;
      console.log('List Rank loaded:', this.listRank);
      this.cdr.detectChanges();
    });
  }

  findAllSimulators() {
    this.simulatorService.findAll().then((res) => {
      console.log('Simulator List:', res);
      this.simulatorList = res;
      this.filteredSimulators = [...this.simulatorList];
      this.editFilteredSimulators = [...this.simulatorList];
      this.cdr.detectChanges();
    });
  }

  findTest(evt: any) {
    const rankId = evt.target.value;
    console.log('Rank ID selected:', rankId);

    if (rankId === '-1') {
      this.listTest = [...this.listTestOriginal];
      this.cdr.detectChanges();
    } else {
      this.rankService
        .findSimulatorById(rankId)
        .then((res) => {
          // Lọc chỉ những test có status = true
          const activeTests = res.filter((test: any) => test.status === true);

          // Map rank.name cho filtered tests
          const testsWithRankName = activeTests.map((test: any) => {
            if (test.rank && typeof test.rank === 'number') {
              const foundRank = this.listRank.find(
                (rank: any) => rank.id === test.rank
              );
              if (foundRank) {
                test.rank = {
                  id: foundRank.id,
                  name: foundRank.name,
                };
              }
            } else if (test.rank && test.rank.id) {
              const foundRank = this.listRank.find(
                (rank: any) => rank.id === test.rank.id
              );
              if (foundRank) {
                test.rank.name = foundRank.name;
              }
            }
            return test;
          });

          this.listTest = testsWithRankName;
          this.cdr.detectChanges();
        })
        .catch((error) => {
          console.error(
            'Lỗi khi lấy danh sách đề thi simulator theo rank:',
            error
          );
          this.listTest = [];
          this.cdr.detectChanges();
        });
    }
  }

  // Các hàm cho modal add
  filterSimulators() {
    if (!this.searchTerm || this.searchTerm.trim() === '') {
      this.filteredSimulators = this.simulatorList.filter(
        (simulator) =>
          !this.selectedSimulators.some(
            (selected) => selected.id === simulator.id
          )
      );
    } else {
      const searchTermLower = this.searchTerm.toLowerCase().trim();
      this.filteredSimulators = this.simulatorList.filter((simulator) => {
        const isAlreadySelected = this.selectedSimulators.some(
          (selected) => selected.id === simulator.id
        );
        if (isAlreadySelected) return false;

        const title = simulator.title?.toLowerCase() || '';
        const id = simulator.id?.toString() || '';
        return title.includes(searchTermLower) || id.includes(searchTermLower);
      });
    }
    this.cdr.detectChanges();
  }

  onSearchSimulators(event: any) {
    this.searchTerm = event.target.value;
    this.filterSimulators();
  }

  addSimulatorToTest(simulator: any) {
    if (!this.selectedSimulators.some((s) => s.id === simulator.id)) {
      this.selectedSimulators.push(simulator);
      this.filterSimulators();
    }
  }

  removeSimulatorFromTest(simulator: any) {
    const index = this.selectedSimulators.findIndex(
      (s) => s.id === simulator.id
    );
    if (index > -1) {
      this.selectedSimulators.splice(index, 1);
      this.filterSimulators();
    }
  }

  saveTest() {
    if (
      !this.testTitle ||
      !this.testTime ||
      !this.testType ||
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

    if (this.selectedSimulators.length === 0) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Cảnh báo',
        detail: 'Vui lòng chọn ít nhất một simulator!',
      });
      return;
    }

    const testData: any = {
      title: this.testTitle,
      description: this.testDescription,
      type: parseInt(this.testType),
      time: this.testTime,
      passedScore: this.passedScore,
      status: true,
      rank: this.rankId,
      numberOfQuestions: this.selectedSimulators.length,
      testSimulatorDetails: this.selectedSimulators.map((simulator) => ({
        simulator: { id: simulator.id },
        status: true,
      })),
    };

    console.log('Dữ liệu bộ đề simulator:', testData);

    this.testService
      .saveSimulator(testData)
      .then((response) => {
        console.log('Kết quả lưu simulator:', response);

        // Hiển thị toast thành công
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: 'Lưu bộ đề mô phỏng thành công!',
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
        this.cdr.detectChanges();
        this.findAll();
        // Thêm test mới vào list thay vì reload toàn bộ
        this.addNewTestToList(response);
      })
      .catch((error) => {
        console.error('Lỗi khi lưu bộ đề simulator:', error);
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

    // Load simulators đã chọn từ testSimulatorDetails
    if (test.testSimulatorDetails && test.testSimulatorDetails.length > 0) {
      this.editSelectedSimulators = test.testSimulatorDetails
        .filter((detail: any) => detail.status && detail.simulator)
        .map((detail: any) => detail.simulator);
    } else {
      this.editSelectedSimulators = [];
    }

    // Filter danh sách simulators
    this.filterEditSimulators();

    // Mở modal
    const modalElement = document.getElementById('editTestModal');
    if (modalElement) {
      const modal = new (window as any).bootstrap.Modal(modalElement);
      modal.show();
    }
  }

  filterEditSimulators() {
    if (!this.editSearchTerm || this.editSearchTerm.trim() === '') {
      this.editFilteredSimulators = this.simulatorList.filter(
        (simulator) =>
          !this.editSelectedSimulators.some(
            (selected) => selected.id === simulator.id
          )
      );
    } else {
      const searchTermLower = this.editSearchTerm.toLowerCase().trim();
      this.editFilteredSimulators = this.simulatorList.filter((simulator) => {
        const isAlreadySelected = this.editSelectedSimulators.some(
          (selected) => selected.id === simulator.id
        );
        if (isAlreadySelected) return false;

        const title = simulator.title?.toLowerCase() || '';
        const id = simulator.id?.toString() || '';
        return title.includes(searchTermLower) || id.includes(searchTermLower);
      });
    }
    this.cdr.detectChanges();
  }

  onEditSearchSimulators(event: any) {
    this.editSearchTerm = event.target.value;
    this.filterEditSimulators();
  }

  addSimulatorToEditTest(simulator: any) {
    if (!this.editSelectedSimulators.some((s) => s.id === simulator.id)) {
      this.editSelectedSimulators.push(simulator);
      this.filterEditSimulators();
    }
  }

  removeSimulatorFromEditTest(simulator: any) {
    const index = this.editSelectedSimulators.findIndex(
      (s) => s.id === simulator.id
    );
    if (index > -1) {
      this.editSelectedSimulators.splice(index, 1);
      this.filterEditSimulators();
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

    if (this.editSelectedSimulators.length === 0) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Cảnh báo',
        detail: 'Vui lòng chọn ít nhất một simulator!',
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
      numberOfQuestions: this.editSelectedSimulators.length,
      rank: this.editRankId,
      testSimulatorDetails: this.editSelectedSimulators.map((simulator) => ({
        simulator: { id: simulator.id },
        status: true,
      })),
    };

    this.testService
      .updateSimulatorTest(updateData)
      .then((response) => {
        console.log('Kết quả cập nhật simulator:', response);

        // Hiển thị toast thành công
        this.messageService.add({
          severity: 'success',
          summary: 'Thành công',
          detail: 'Cập nhật bộ đề mô phỏng thành công!',
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
          numberOfQuestions: this.editSelectedSimulators.length,
          rank: this.getRankObject(this.editRankId),
          testSimulatorDetails: this.editSelectedSimulators.map(
            (simulator) => ({
              simulator: simulator,
              status: true,
            })
          ),
        };

        // Reset form
        this.resetEditForm();

        // Cập nhật list ngay lập tức
        this.updateListAfterEdit(updatedTest);
      })
      .catch((error) => {
        console.error('Lỗi khi cập nhật bộ đề simulator:', error);

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

  // Method để lấy object rank từ ID
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
    this.editSelectedSimulators = [];
    this.editSearchTerm = '';
    this.editFilteredSimulators = [...this.simulatorList];
    this.cdr.detectChanges();
  }

  updateListAfterEdit(updatedTest: any) {
    console.log('Updating list with:', updatedTest);

    // Cập nhật trong listTestOriginal
    const originalIndex = this.listTestOriginal.findIndex(
      (test) => test.id === updatedTest.id
    );
    if (originalIndex > -1) {
      this.listTestOriginal[originalIndex] = { ...updatedTest };
      console.log('Updated in listTestOriginal at index:', originalIndex);
    }

    // Cập nhật trong listTest hiện tại
    const currentIndex = this.listTest.findIndex(
      (test) => test.id === updatedTest.id
    );
    if (currentIndex > -1) {
      this.listTest[currentIndex] = { ...updatedTest };
      console.log('Updated in listTest at index:', currentIndex);
    }

    // Force detect changes để cập nhật giao diện ngay lập tức
    this.cdr.detectChanges();

    console.log('List updated after edit. Current listTest:', this.listTest);
  }

  // Hàm thêm test mới vào list
  addNewTestToList(newTest: any) {
    // Map rank name cho test mới
    if (newTest.rank && typeof newTest.rank === 'number') {
      const foundRank = this.listRank.find(
        (rank: any) => rank.id === newTest.rank
      );
      if (foundRank) {
        newTest.rank = {
          id: foundRank.id,
          name: foundRank.name,
        };
      }
    }

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
    this.selectedSimulators = [];
    this.searchTerm = '';
    this.filteredSimulators = [...this.simulatorList];
    this.cdr.detectChanges();
  }

  deleteSimulator(testId: any) {
    this.confirmationService.confirm({
      message: 'Bạn có chắc chắn muốn xóa bộ đề mô phỏng này?',
      header: 'Xác nhận xóa',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Có',
      rejectLabel: 'Không',
      accept: () => {
        this.testService
          .delete(testId)
          .then((response) => {
            console.log('Kết quả xóa simulator:', response);

            // Hiển thị toast thành công
            this.messageService.add({
              severity: 'success',
              summary: 'Thành công',
              detail: 'Xóa bộ đề mô phỏng thành công!',
            });

            // Tự động cập nhật listTest mà không cần reload toàn bộ
            this.updateListAfterDelete(testId);
          })
          .catch((error) => {
            console.error('Lỗi khi xóa bộ đề simulator:', error);

            // Hiển thị toast lỗi
            this.messageService.add({
              severity: 'error',
              summary: 'Lỗi',
              detail: 'Có lỗi xảy ra khi xóa bộ đề: ' + error.message,
            });
          });
      },
      reject: () => {
        console.log('User cancelled delete operation');
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
}
