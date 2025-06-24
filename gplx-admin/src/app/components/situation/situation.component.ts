import {
  Component,
  OnInit,
  AfterViewInit,
  OnDestroy,
  ViewChild,
  ElementRef,
} from '@angular/core';
import { SimualtorService } from 'src/app/service/simulator.service';

declare var $: any;

@Component({
  selector: 'app-situation',
  templateUrl: './situation.component.html',
  styleUrls: ['./situation.component.css'],
})
export class SituationComponent implements OnInit, AfterViewInit, OnDestroy {
  @ViewChild('videoPlayer') videoPlayer!: ElementRef<HTMLVideoElement>;

  testTitle: string = '';
  testDescription: string = '';
  testTime: number | null = null;
  testType: string = '';
  situations: any[] = [];
  selectedSituation: any = null;
  videoLoading: boolean = false;

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
    this.simulatorService
      .findAll()
      .then((res) => {
        this.situations = res;
        console.log('Situations loaded:', res);
      })
      .catch((error) => {
        console.error('Error loading situations:', error);
      });
  }

  openVideoModal(situation: any) {
    console.log('Opening video modal for situation:', situation);
    this.selectedSituation = situation;
    this.videoLoading = true;

    // Mở modal
    const modalElement = document.getElementById('videoModal');
    if (modalElement) {
      const modal = new (window as any).bootstrap.Modal(modalElement);
      modal.show();

      // Xử lý khi video được load
      setTimeout(() => {
        if (this.videoPlayer && this.videoPlayer.nativeElement) {
          const video = this.videoPlayer.nativeElement;

          video.addEventListener('loadstart', () => {
            this.videoLoading = true;
          });

          video.addEventListener('canplay', () => {
            this.videoLoading = false;
          });

          video.addEventListener('error', (e) => {
            console.error('Video error:', e);
            this.videoLoading = false;
          });
        }
      }, 100);
    }
  }

  closeVideoModal() {
    // Dừng video khi đóng modal
    if (this.videoPlayer && this.videoPlayer.nativeElement) {
      const video = this.videoPlayer.nativeElement;
      video.pause();
      video.currentTime = 0;
    }

    // Reset state
    this.selectedSituation = null;
    this.videoLoading = false;

    console.log('Video modal closed');
  }

  saveTest(): void {
    console.log('Saving test...');
    // Logic lưu test
  }
}
