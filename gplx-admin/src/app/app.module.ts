import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { QuestionComponent } from './components/question/question.component';
import { TestComponent } from './components/test/test.component';
import { FormsModule } from '@angular/forms';
import { BaseUrlService } from './service/baseUrl.service';
import { QuestionService } from './service/question.service';
import { HttpClientModule } from '@angular/common/http';
import { TestService } from './service/test.service';
import { RankService } from './service/rank.service';
import { SimulatorComponent } from './components/simulator-test/simulator.component';
import { SituationComponent } from './components/situation/situation.component';

@NgModule({
  declarations: [
    AppComponent,
    QuestionComponent,
    TestComponent,
    SimulatorComponent,
    SituationComponent
  ],
  imports: [BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
  ],
  providers: [BaseUrlService,
    QuestionService,
    TestService,
    RankService,
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
