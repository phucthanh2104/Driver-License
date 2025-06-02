import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { QuestionComponent } from './components/question/question.component';
import { TestComponent } from './components/test/test.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BaseUrlService } from './service/baseUrl.service';
import { QuestionService } from './service/question.service';
import { HttpClientModule } from '@angular/common/http';
import { TestService } from './service/test.service';
import { RankService } from './service/rank.service';
import { SimulatorComponent } from './components/simulator-test/simulator.component';
import { SituationComponent } from './components/situation/situation.component';
import { AddQuestionComponent } from './components/question/add-question.component copy';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations'; // Cần cho PrimeNG
import { ConfirmDialogModule } from 'primeng/confirmdialog'; // Module cho ConfirmDialog
import { ToastModule } from 'primeng/toast'; // Module cho Toast
import { ConfirmationService, MessageService } from 'primeng/api';

@NgModule({
  declarations: [
    AppComponent,
    QuestionComponent,
    TestComponent,
    SimulatorComponent,
    SituationComponent,
    AddQuestionComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    ConfirmDialogModule,
    ToastModule,
    ReactiveFormsModule,
  ],
  providers: [
    BaseUrlService,
    QuestionService,
    TestService,
    RankService,
    ConfirmationService,
    MessageService,
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
