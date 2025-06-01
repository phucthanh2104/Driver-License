import { Injectable } from "@angular/core";

@Injectable()
export class BaseUrlService {
  constructor() {}

  private baseUrl: string = 'http://localhost:8080/api/';
  private imageUrl: string = 'http://localhost:8080/assets/images/';

  getBaseUrl(): string {
    return this.baseUrl;
  }

  getImageUrl(): string {
    return this.imageUrl;
  }
}