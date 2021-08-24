import React, { useState } from 'react'
import styled from 'styled-components'

import { TabBar, TabItem } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps } from './ScheduleCard'
import { Table, TableHead, TableBody, TableRow, TableHeadCell, TableBodyCell } from './Shared/Table'

type GroupedSchedules = { [key: string]: ScheduleTable}
type ScheduleTable = {trackList: TrackList, rows: Row[]}
type TrackList = string[]
type Row = { time: string, schedules: Array<CardProps | null> }

interface Props {
  groupedSchedules: GroupedSchedules
  i18n: {
    startEnd: string
  }
}

export const ScheduleTable: React.VFC<Props> = (props) => {
  const { groupedSchedules, i18n } = props
  const current = window.location.hash === "" ? Object.keys(groupedSchedules)[0] : window.location.hash.replace('#', '')


  const [currentKey, setCurrentDate] = useState(current)

  const handleTabClick = (date) =>  {
    window.location.hash = '#' + date
    setCurrentDate(date)
  }

  return (
    <>
      <TabBar>
        {Object.keys(groupedSchedules).map(date => {
          return <TabItem id={date} onClick={() => {handleTabClick(date)}} selected={date === currentKey}>{date}</TabItem>
        })}
      </TabBar>
      <TableWrapper>
        <Table>
          <TableHead>
            <TableRow>
              <TableHeadCell width="20%">{i18n.startEnd}</TableHeadCell>
              {groupedSchedules[currentKey].trackList.map(track => <TableHeadCell key={track}  width="40%" textCenter>{track}</TableHeadCell>)}
            </TableRow>
          </TableHead>
          <TableBody>
            {groupedSchedules[currentKey].rows.map(row => {
              return (
                <TableRow>
                  <TableBodyCell noSidePadding>{row.time}</TableBodyCell>
                  {row.schedules.map(row => row === null ? <TableBodyCell /> : <TableBodyCell><CellItemStretcher><ScheduleCard {...row} /></CellItemStretcher></TableBodyCell>)}
                </TableRow>
              )
            })}
          </TableBody>
        </Table>
      </TableWrapper>
    </>
  )
}

const TableWrapper = styled.div`
  margin-top: 16px;
`
/* テーブルセル内の要素の幅高さ 100% にする */
const CellItemStretcher = styled.div`
  display: flex;
  height: 100%;
  > * {
    width: 100%;
  }
`

export default ScheduleTable
