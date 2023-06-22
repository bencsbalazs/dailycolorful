import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ResultsComponent } from './results/results.component';
import { UploadComponent } from './upload/upload.component';
import { VotingComponent } from './voting/voting.component';
import { HomeComponent } from './home/home.component';

const routes: Routes = [
  { path: 'voting', component: VotingComponent },
  { path: 'upload', component: UploadComponent },
  { path: 'results', component: ResultsComponent },
  { path: 'home', component: HomeComponent },
  { path: '', redirectTo: '/home', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
