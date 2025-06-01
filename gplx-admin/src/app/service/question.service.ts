import { Injectable } from "@angular/core";
import { BaseUrlService } from "./baseUrl.service";
import { HttpClient } from "@angular/common/http";
import { lastValueFrom } from 'rxjs';

@Injectable()
export class QuestionService { 
    constructor(
        private baseUrlService: BaseUrlService,
        private httpClient : HttpClient
    ) { }
    
    async findAll() {
        return await lastValueFrom(this.httpClient.get(this.baseUrlService.getBaseUrl() + "question/findAll"));
    }
}