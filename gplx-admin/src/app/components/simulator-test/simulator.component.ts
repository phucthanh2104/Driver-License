import {
  Component,
  OnInit,
  AfterViewInit,
  OnDestroy,
  ChangeDetectorRef,
} from '@angular/core';
import { RankService } from 'src/app/service/rank.service';
import { TestService } from 'src/app/service/test.service';

declare var $: any;

@Component({
  selector: 'app-root',
  templateUrl: './simulator.component.html',
  styleUrls: ['./simulator.component.css'],
})
export class SimulatorComponent implements OnInit, AfterViewInit, OnDestroy {
  listTest: any[] = [];
  listTestOfRank: any[] = [];
  listRank: any[] = [];
  listTestOriginal: any[] = [];

  // Biến cho modal
  testTitle: string = '';
  testDescription: string = '';
  testTime: number | null = null;
  testType: string = '';

  private dataTable: any;

  constructor(
    private testService: TestService,
    private rankService: RankService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    console.log('Simulator Component initialized');
    this.findAll();
    this.findListRank();
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

  // XÓA hàm reloadDataTable() - gây lỗi
  refreshTable(): void {
    this.cdr.detectChanges();
    // DataTable sẽ tự động cập nhật từ DOM
    if (this.dataTable) {
      this.dataTable.draw();
    }
  }

  findAll() {
    this.testService
      .findAllSimulator()
      .then((res) => {
        console.log('List Simulator Tests from API:', res);

        // Lọc chỉ những test có status = true
        const activeTests = res.filter((test: any) => test.status === true);

        this.listTestOriginal = activeTests;
        this.listTest = [...this.listTestOriginal];

        // Chỉ cần detectChanges, DataTable sẽ tự cập nhật
        this.cdr.detectChanges();

        console.log('Filtered active simulator tests:', this.listTest);
      })
      .catch((error) => {
        console.error('Lỗi khi lấy danh sách simulator tests:', error);
        this.listTest = [];
        this.listTestOriginal = [];
        this.cdr.detectChanges();
      });
  }

  findTest(evt: any) {
    const rankId = evt.target.value;
    console.log('Rank ID selected:', rankId);

    if (rankId === '-1') {
      // Nếu chọn "Tất cả", hiển thị tất cả test có status = true
      this.listTest = [...this.listTestOriginal];
      console.log('Showing all active simulator tests:', this.listTest);
      this.cdr.detectChanges();
    } else {
      // Gọi API để lấy danh sách đề thi theo rankId
      this.rankService
        .findSimulatorById(rankId)
        .then((res) => {
          console.log('API response for simulator rank:', res);

          // Lọc chỉ những test có status = true
          const activeTests = res.filter((test: any) => test.status === true);
          console.log('Active simulator tests for rank:', activeTests);

          this.listTest = activeTests;
          this.cdr.detectChanges();
        })
        .catch((error) => {
          console.error(
            'Lỗi khi lấy danh sách đề thi simulator theo rank:',
            error
          );
          // Đặt danh sách rỗng khi không có test hoặc có lỗi
          this.listTest = [];
          console.log('No simulator tests found for rank, setting empty list');
          this.cdr.detectChanges();
        });
    }
  }

  findListRank() {
    this.rankService.findAll().then((res) => {
      this.listRank = res;
      console.log('List Rank:', res);
      this.cdr.detectChanges();
    });
  }

  // Lưu bộ đề simulator
  // saveTest() {
  //   if (!this.testTitle || !this.testTime || !this.testType) {
  //     alert('Vui lòng điền đầy đủ thông tin tiêu đề, thời gian và loại!');
  //     return;
  //   }

  //   const testData = {
  //     title: this.testTitle,
  //     description: this.testDescription,
  //     time: this.testTime,
  //     type: this.testType,
  //     status: true,
  //   };

  //   console.log('Dữ liệu bộ đề simulator:', testData);

  //   // Gọi API lưu test simulator
  //   this.testService
  //     .saveSimulator(testData)
  //     .then((response) => {
  //       console.log('Kết quả lưu simulator:', response);
  //       alert('Lưu bộ đề mô phỏng thành công!');

  //       // Đóng modal
  //       const modalElement = document.getElementById('addTestModal');
  //       if (modalElement) {
  //         const modal = (window as any).bootstrap.Modal.getInstance(
  //           modalElement
  //         );
  //         modal.hide();
  //       }

  //       this.resetTestForm();
  //       this.findAll(); // Reload dữ liệu
  //     })
  //     .catch((error) => {
  //       console.error('Lỗi khi lưu bộ đề simulator:', error);
  //       alert('Có lỗi xảy ra khi lưu bộ đề: ' + error.message);
  //     });
  // }

  // // Reset form sau khi lưu
  // resetTestForm() {
  //   this.testTitle = '';
  //   this.testDescription = '';
  //   this.testTime = null;
  //   this.testType = '';
  //   this.cdr.detectChanges();
  // }

  // // Xóa test simulator
  // deleteSimulator(testId: any) {
  //   if (confirm('Bạn có chắc chắn muốn xóa bộ đề mô phỏng này?')) {
  //     this.testService
  //       .deleteSimulator(testId)
  //       .then((response) => {
  //         console.log('Kết quả xóa simulator:', response);
  //         alert('Xóa bộ đề mô phỏng thành công!');
  //         this.findAll(); // Reload dữ liệu
  //       })
  //       .catch((error) => {
  //         console.error('Lỗi khi xóa bộ đề simulator:', error);
  //         alert('Có lỗi xảy ra khi xóa bộ đề: ' + error.message);
  //       });
  //   }
  // }
}
