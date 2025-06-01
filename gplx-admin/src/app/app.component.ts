import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent implements OnInit {
  activeLink: string | null = 'test';
  ngOnInit(): void {}
  title = 'fe-admin';

  setActiveLink(link: string) {
    this.activeLink = link;
  }
}
