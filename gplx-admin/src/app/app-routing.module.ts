import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { QuestionComponent } from './components/question/question.component';
import { TestComponent } from './components/test/test.component';
import { SimulatorComponent } from './components/simulator-test/simulator.component';
import { SituationComponent } from './components/situation/situation.component';
import { AddQuestionComponent } from './components/question/add-question.component copy';

const routes: Routes = [
  {
    path: '',
    component: TestComponent,
  },
  {
    path: 'question',
    component: QuestionComponent,
  },
  {
    path: 'test',
    component: TestComponent,
  },
  {
    path: 'add-question',
    component: AddQuestionComponent,
  },
  {
    path: 'simulator',
    component: SimulatorComponent,
  },
  {
    path: 'situation',
    component: SituationComponent,
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
