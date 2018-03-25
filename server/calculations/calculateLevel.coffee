import Table from '../models/table'
import Result from '../models/result'
import logger from '../log'
import isContestRequired from '../../client/lib/isContestRequired'

export default calculateLevel = (user, baseLevel, lastDate) ->
    for bigLevel in [1..10]
        for smallLevel in ["А", "Б", "В", "Г"]
            tableId = bigLevel + smallLevel
            level = tableId
            _debug_marker = {qwe: '120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120_120'}
            table = await Table.findById(tableId)
            if not table
                continue
            probNumber = 0
            probAc = 0
            for subTableId in table.tables
                _debug_marker = {qwe: '121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121_121'}
                subTable = await Table.findById(subTableId)
                if not subTable
                    continue
                for prob in subTable.problems
                    if isContestRequired(subTable.name)
                        probNumber++
                    _debug_marker = {qwe: '122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122_122'}
                    result = await Result.findByUserAndTable(user, prob)
                    if not result
                        continue
                    if result.solved == 0
                        continue
                    submitDate = new Date(result.lastSubmitTime)
                    if submitDate >= lastDate
                        continue
                    probAc++
            needProblem = probNumber
            if smallLevel == "В"
                needProblem = probNumber * 0.5
            else if smallLevel == "Г"
                needProblem = probNumber * 0.3333
            if (probAc < needProblem) and ((!baseLevel) or (baseLevel <= level))
                logger.debug "calculated level", user, level
                return level
    return "inf"
