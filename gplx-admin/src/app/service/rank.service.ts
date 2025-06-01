import { Injectable } from "@angular/core";
import { BaseUrlService } from "./baseUrl.service";
import { HttpClient } from "@angular/common/http";
import { lastValueFrom } from 'rxjs';

@Injectable()
export class RankService { 
    constructor(
        private baseUrlService: BaseUrlService,
        private httpClient : HttpClient
    ) { }
    
    async findAll() :Promise<any> {
        return await lastValueFrom(this.httpClient.get(this.baseUrlService.getBaseUrl() + "test/findAllRank"));
    }

      async findTestById(id : number) :Promise<any> {
        return await lastValueFrom(this.httpClient.get(this.baseUrlService.getBaseUrl() + "test/findTestByRankId/" + id));
    }
    async findSimulatorById(id : number) :Promise<any> {
        return await lastValueFrom(this.httpClient.get(this.baseUrlService.getBaseUrl() + "test/findSimulatorByRankId/" + id));
    }
}