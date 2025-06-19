import { Component, OnInit, AfterViewInit, OnDestroy } from '@angular/core';
import { SimualtorService } from 'src/app/service/simulator.service';

declare var $: any;

@Component({
  selector: 'app-situation',
  templateUrl: './situation.component.html',
  styleUrls: ['./situation.component.css'],
})
export class SituationComponent implements OnInit, AfterViewInit, OnDestroy {
  testTitle: string = '';
  testDescription: string = '';
  testTime: number | null = null;
  testType: string = '';
  situations : any ={}
  constructor(private simulatorService: SimualtorService) {}

  ngOnInit(): void {
    this.findAll();
  }

  ngAfterViewInit(): void {
    // Đợi một chút để DOM render xong rồi mới khởi tạo DataTable
    setTimeout(() => {
      this.initDataTable();
    }, 100);
  }

  ngOnDestroy(): void {
    // Destroy DataTable khi component bị hủy
    try {
      if ($.fn.DataTable.isDataTable('#basic-datatable')) {
        $('#basic-datatable').DataTable().destroy();
      }
    } catch (error) {
      console.log('Error destroying DataTable:', error);
    }
  }

  initDataTable(): void {
    try {
      $('#basic-datatable').DataTable({
        responsive: true,
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
          [10, 25, 50, 120],
          [10, 25, 50, 120],
        ],
      });
      console.log('DataTable initialized successfully');
    } catch (error) {
      console.error('Error initializing DataTable:', error);
    }
  }

  findAll() {
    this.simulatorService.findAll().then((res) => {
      this.situations = res;
      console.log(res);
      
    });
  }

  saveTest(): void {
    console.log('Saving test...');
    // Logic lưu test
  }
}
