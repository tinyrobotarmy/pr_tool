import * as React from 'react'
import { Link } from 'react-router-dom'

import Main from '../components/Main'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import '../../../node_modules/react-vis/dist/style.css';
import {FlexibleWidthXYPlot, LineMarkSeries, VerticalGridLines, HorizontalGridLines, XAxis, YAxis, Crosshair} from 'react-vis';

import moment from 'moment'

const MARGIN = {
  left: 50,
  right: 50,
  bottom: 100,
  top: 20
};

interface SeriesItem {
  x: any;
  y: number;
}

interface Repo {
  id: number;
  name: string;
  url: string;
}

// Interface for the Counter component state
interface RepoState {
  repo: Repo,
  tickCount: number,
  changedFilesMax: number,
  mergedMax: number,
  merged_series: Array<SeriesItem>,
  changed_files_series: Array<SeriesItem>,
  mergedCrosshairValues: Array<any>,
  filesCrosshairValues: Array<any>,
}

const initialState = { 
  repo: {id:0, name: '', url: '', },
  tickCount: 0,
  changedFilesMax: 0,
  mergedMax: 0,
  merged_series: [],
  changed_files_series: [],
  mergedCrosshairValues: [{x:null, y: null}], 
  filesCrosshairValues: [{x:null, y: null}], 
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
          merged_series: result.data.merged_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
          changed_files_series: result.data.changed_files_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
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

  getYMax(series: Array<any>) {
    if(series.length == 0) {
      return 0
    }
    let max = series.reduce((a,b) => {
      return {y: Math.max(a.y, b.y)}
    }).y
    return max
  }

  public render(): JSX.Element {
    return (
      <Main>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10"><h2>Pull Request Data for { this.state.repo.name }</h2></div>
          <div className="col-sm-1"></div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <h5 className="sub-head">Rolling 1 month average of time to close a Pull Request</h5>
          </div>
          <div className="col-sm-6">
            <h5 className="sub-head">Rolling 1 month average of files in a Pull Request</h5>
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
      </Main>
    )
  }
}