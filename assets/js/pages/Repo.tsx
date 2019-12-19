import * as React from 'react'
import { Link } from 'react-router-dom'

import Main from '../components/Main'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import '../../../node_modules/react-vis/dist/style.css';
import {FlexibleWidthXYPlot, LineMarkSeries, VerticalGridLines, HorizontalGridLines, XAxis, YAxis, Crosshair, DiscreteColorLegend} from 'react-vis';

import moment from 'moment'
// import DiscreteColorLegend from 'legends/discrete-color-legend';

const MARGIN = {
  left: 50,
  right: 50,
  bottom: 100,
  top: 20
};

const ITEMS = [
  {title: 'Comments', color: '#21a03a', strokeWidth: 4},
  {title: 'Reviews', color: '#eed731', strokeWidth: 4},
];

interface SeriesItem {
  x: any;
  y: number;
}

interface PullRequest {
  external_id: number;
  days_to_merge: number;
  changed_files: number;
  closed_at: Date;
  merged_at: Date;
  title: string;
  author: string;
}

interface Repo {
  id: number;
  name: string;
  url: string;
  pull_requests: Array<PullRequest>;
}

// Interface for the Counter component state
interface RepoState {
  repo: Repo,
  tickCount: number,
  changedFilesMax: number,
  mergedMax: number,
  changesMax: number,
  commentsMax: number,
  merged_series: Array<SeriesItem>,
  changed_files_series: Array<SeriesItem>,
  changes_series: Array<SeriesItem>,
  comments_series: Array<SeriesItem>,
  reviewers_series: Array<SeriesItem>,
  mergedCrosshairValues: Array<any>,
  filesCrosshairValues: Array<any>,
  changesCrosshairValues: Array<any>,
  commentsCrosshairValues: Array<any>,
}

const initialState = {
  repo: {id:0, name: '', url: '', pull_requests: []},
  tickCount: 0,
  changedFilesMax: 0,
  changesMax: 0,
  mergedMax: 0,
  commentsMax: 0,
  merged_series: [],
  changed_files_series: [],
  changes_series: [],
  comments_series: [],
  reviewers_series: [],
  mergedCrosshairValues: [{x:null, y: null}],
  filesCrosshairValues: [{x:null, y: null}],
  changesCrosshairValues: [{x:null, y: null}],
  commentsCrosshairValues: [{x:null, y: null}],
}

export default class RepoPage extends React.Component<{}, RepoState> {
  constructor(props: {}) {
    super(props)

    // Set the initial state of the component in a constructor.
    this.state = initialState
    this.onMouseLeaveMerged = this.onMouseLeaveMerged.bind(this);
    this.onNearestXMerged = this.onNearestXMerged.bind(this);
    this.onMouseLeaveFiles = this.onMouseLeaveFiles.bind(this);
    this.onNearestXFiles = this.onNearestXFiles.bind(this);
    this.onMouseLeaveChanges = this.onMouseLeaveChanges.bind(this);
    this.onNearestXChanges = this.onNearestXChanges.bind(this);
    this.onMouseLeaveComments = this.onMouseLeaveComments.bind(this);
    this.onNearestXComments = this.onNearestXComments.bind(this);
  }

  componentDidMount() {
    let id = this.props.match.params.id
    fetch('http://localhost:4000/api/git_repos/' + id, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    }})
      .then((results) => {
        return results.json();
      })
      .then((result) => {
        this.setState({
          repo: result.data,
          tickCount: result.data.length,
          changedFilesMax: this.getYMax(result.data.changed_files_series),
          mergedMax: this.getYMax(result.data.merged_series),
          changesMax: this.getYMax(result.data.changes_series),
          commentsMax: Math.max(this.getYMax(result.data.comments_series), this.getYMax(result.data.reviewers_series)),
          merged_series: result.data.merged_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
          changed_files_series: result.data.changed_files_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
          changes_series: result.data.changes_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
          comments_series: result.data.comments_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
          reviewers_series: result.data.reviewers_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
        })
      })
  }

  onMouseLeaveMerged(){
    this.setState({mergedCrosshairValues: [{x:null, y: null}]});
  }
  onNearestXMerged(value, {event, innerX, index}) {
    this.setState({
      mergedCrosshairValues: [value]
    });
  }

  onMouseLeaveFiles(){
    this.setState({filesCrosshairValues: [{x:null, y: null}]});
  }
  onNearestXFiles(value, {event, innerX, index}) {
    this.setState({
      filesCrosshairValues: [value]
    });
  }

  onMouseLeaveChanges(){
    this.setState({changesCrosshairValues: [{x:null, y: null}]});
  }
  onNearestXChanges(value, {event, innerX, index}) {
    this.setState({
      changesCrosshairValues: [value]
    });
  }

  onMouseLeaveComments(){
    this.setState({commentsCrosshairValues: [{x:null, y: null}]});
  }
  onNearestXComments(value, {event, innerX, index}) {
    this.setState({
      commentsCrosshairValues: [value]
    });
  }

  getYMax(series: Array<any>) {
    if(series.length == 0) {
      return 0
    }
    let max = series.reduce((a,b) => {
      return {y: Math.max(a.y, b.y)}
    }).y
    return max
  }

  avg(array: Array<{PullRequest}>, field: any) : String {
    let sum = array.reduce((a, b) => a + (b[field] || 0), 0)
    let unrounded = sum / array.length
    return unrounded.toFixed(2)
  }

  public render(): JSX.Element {
    return (
      <Main>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <h2>Pull Request Data for { this.state.repo.name }</h2>
            <p>Summary details</p>
          </div>
          <div className="col-sm-1"></div>
        </div>
        <div className="row">
        <div className="col-sm-1"></div>
        <div className="col-sm-10">
          <dl className="row">
            <dt className="col-sm-3">Total Pull Requests</dt>
            <dd className="col-sm-9">{this.state.repo.pull_requests.length}</dd>
            <dt className="col-sm-3">Pull Requests still open</dt>
            <dd className="col-sm-9">{this.state.repo.pull_requests.filter(pull => pull.closed_at == null).length}</dd>
            <dt className="col-sm-3">Total avg time to merge</dt>
            <dd className="col-sm-9">{ this.avg(this.state.repo.pull_requests, "days_to_merge") }</dd>
            <dt className="col-sm-3">Total avg files changed</dt>
            <dd className="col-sm-9">{ this.avg(this.state.repo.pull_requests, "changed_files") }</dd>
          </dl>
        </div>
        <div className="col-sm-1"></div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <h5 className="sub-head">Rolling 1 month average of time to close</h5>
          </div>
          <div className="col-sm-6">
            <h5 className="sub-head">Rolling 1 month average of files</h5>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <FlexibleWidthXYPlot margin={MARGIN} height={400}
              onMouseLeave={this.onMouseLeaveMerged}
              yDomain={[0, this.state.mergedMax]}>
              <HorizontalGridLines />
              <VerticalGridLines />
              <XAxis
                tickLabelAngle={-45}
                tickTotal={this.state.tickCount}
                tickFormat={d => moment(d).format("MMM YY") }
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }} />
              <YAxis title="Avg time to close"
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }}
              />
              <LineMarkSeries curve={'curveMonotoneX'}
                color={'#212ca5'}
                getNull={d => d.y !== null}
                data={this.state.merged_series} onNearestX={this.onNearestXMerged}
              />
              <Crosshair values={this.state.mergedCrosshairValues} className={'cross'} style={{line:{background: '#3e3e3e'}}}>
                <div>
                  <p>Avg Time: {this.state.mergedCrosshairValues[0].y}</p>
                  <p>On: {moment(this.state.mergedCrosshairValues[0].x).format("MMM YY")}</p>
                </div>
              </Crosshair>
            </FlexibleWidthXYPlot>
          </div>
          <div className="col-sm-6">
          <FlexibleWidthXYPlot margin={MARGIN} height={400}
            onMouseLeave={this.onMouseLeaveFiles}
            yDomain={[0, this.state.changedFilesMax]}>
              <HorizontalGridLines />
              <VerticalGridLines />
              <XAxis
                tickLabelAngle={-45}
                tickTotal={this.state.tickCount}
                tickFormat={d => moment(d).format("MMM YY") }
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }} />
              <YAxis title="Avg count of files changed"
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }}
              />
              <LineMarkSeries curve={'curveMonotoneX'}
                getNull={d => d.y !== null}
                data={this.state.changed_files_series} onNearestX={this.onNearestXFiles}
              />
              <Crosshair values={this.state.filesCrosshairValues} className={'cross'} style={{line:{background: '#3e3e3e'}}}>
                <div>
                  <p>Changed: {this.state.filesCrosshairValues[0].y}</p>
                  <p>On: {moment(this.state.filesCrosshairValues[0].x).format("MMM YY")}</p>
                </div>
              </Crosshair>
            </FlexibleWidthXYPlot>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <h5 className="sub-head">Rolling 1 month average of changes (additions and deletions)</h5>
          </div>
          <div className="col-sm-6">
          <h5 className="sub-head">Rolling 1 month average of comments and reviewers</h5>
          <DiscreteColorLegend orientation="horizontal" width={300} items={ITEMS} />
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <FlexibleWidthXYPlot margin={MARGIN} height={400}
              onMouseLeave={this.onMouseLeaveChanges}
              yDomain={[0, this.state.changesMax]}>
              <HorizontalGridLines />
              <VerticalGridLines />
              <XAxis
                tickLabelAngle={-45}
                tickTotal={this.state.tickCount}
                tickFormat={d => moment(d).format("MMM YY") }
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }} />
              <YAxis title="Avg count of changes"
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }}
              />
              <LineMarkSeries curve={'curveMonotoneX'}
                color={'#e54a46'}
                getNull={d => d.y !== null}
                data={this.state.changes_series} onNearestX={this.onNearestXChanges}
              />
              <Crosshair values={this.state.changesCrosshairValues} className={'cross'} style={{line:{background: '#3e3e3e'}}}>
                <div>
                  <p>Changes: {this.state.changesCrosshairValues[0].y}</p>
                  <p>On: {moment(this.state.changesCrosshairValues[0].x).format("MMM YY")}</p>
                </div>
              </Crosshair>
            </FlexibleWidthXYPlot>
          </div>
          <div className="col-sm-6">
            <FlexibleWidthXYPlot margin={MARGIN} height={400}
              onMouseLeave={this.onMouseLeaveComments}
              yDomain={[0, this.state.commentsMax]}>
              <HorizontalGridLines />
              <VerticalGridLines />
              <XAxis
                tickLabelAngle={-45}
                tickTotal={this.state.tickCount}
                tickFormat={d => moment(d).format("MMM YY") }
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }} />
              <YAxis title="Avg count of comments"
                style={{
                  line: {stroke: '#8b8b8b'},
                  ticks: {stroke: '#8b8b8b'},
                  text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
                }}
              />
              <LineMarkSeries curve={'curveMonotoneX'}
                color={'#21a03a'}
                getNull={d => d.y !== null}
                data={this.state.comments_series} onNearestX={this.onNearestXComments}
              />
              <LineMarkSeries curve={'curveMonotoneX'}
                color={'#eed731'}
                getNull={d => d.y !== null}
                data={this.state.reviewers_series}
              />
              <Crosshair values={this.state.commentsCrosshairValues} className={'cross'} style={{line:{background: '#3e3e3e'}}}>
                <div>
                  <p>Comments: {this.state.commentsCrosshairValues[0].y}</p>
                  <p>On: {moment(this.state.commentsCrosshairValues[0].x).format("MMM YY")}</p>
                </div>
              </Crosshair>
            </FlexibleWidthXYPlot>
          </div>
        </div>
      </Main>
    )
  }
}