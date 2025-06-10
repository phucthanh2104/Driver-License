import { Injectable } from "@angular/core";
import { BaseUrlService } from "./baseUrl.service";
import { HttpClient } from "@angular/common/http";
import { lastValueFrom } from 'rxjs';

@Injectable()
export class TestService {
  constructor(
    private baseUrlService: BaseUrlService,
    private httpClient: HttpClient
  ) {}

  async findAllTest(): Promise<any> {
    return await lastValueFrom(this.httpClient.get(this.baseUrlService.getBaseUrl() + 'test/findAllTest'));
  }

  async findAllSimulator(): Promise<any> {
    return await lastValueFrom(this.httpClient.get(this.baseUrlService.getBaseUrl() + 'test/findAllSimulator'));
  }
  async save(test : any): Promise<any> {
    return await lastValueFrom(this.httpClient.post(this.baseUrlService.getBaseUrl() + 'test/addTestDetail', test));
  }
}