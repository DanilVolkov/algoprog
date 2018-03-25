mongoose = require('mongoose')

import calculateChocos from '../calculations/calculateChocos'
import calculateRatingEtc from '../calculations/calculateRatingEtc'
import calculateLevel from '../calculations/calculateLevel'
import calculateCfRating from '../calculations/calculateCfRating'

import logger from '../log'

import updateResults from '../calculations/updateResults'

import sleep from '../lib/sleep'

SEMESTER_START = "2016-06-01"

usersSchema = new mongoose.Schema
    _id: String,
    name: String,
    userList: String,
    chocos: [Number],
    level:
        current: String,
        start: String,
        base: String,
    active: Boolean,
    ratingSort: Number,
    byWeek: {solved: mongoose.Schema.Types.Mixed, ok: mongoose.Schema.Types.Mixed},
    rating: Number,
    activity: Number,
    cf:
        login: String,
        rating: Number,
        color: String,
        activity: Number,
        progress: Number

usersSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a user"

usersSchema.methods.updateChocos = ->
    _debug_marker = {qwe: '248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248_248'}
    @chocos = await calculateChocos @_id
    logger.debug "calculated chocos", @name, @chocos
    @update({$set: {chocos: @chocos}})

usersSchema.methods.updateRatingEtc = ->
    _debug_marker = {qwe: '249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249_249'}
    res = await calculateRatingEtc this
    logger.debug "updateRatingEtc", @name, res
    @update({$set: res})

usersSchema.methods.updateLevel = ->
    _debug_marker = {qwe: '250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250_250'}
    @level.current = await calculateLevel @_id, @level.base, new Date("2100-01-01")
    _debug_marker = {qwe: '251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251_251'}
    @level.start = await calculateLevel @_id, @level.base, new Date(SEMESTER_START)
    @update({$set: {level: @level}})

usersSchema.methods.updateCfRating = ->
    logger.debug "Updating cf rating ", @name
    _debug_marker = {qwe: '252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252_252'}
    res = await calculateCfRating this
    logger.debug "Updated cf rating ", @name, res
    if not res
        return
    res.login = @cf.login
    @update({$set: {cf: res}})

usersSchema.methods.setBaseLevel = (level) ->
    _debug_marker = {qwe: '253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253_253'}
    await @update({$set: {"level.base": level}})
    @level.base = level
    _debug_marker = {qwe: '254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254_254'}
    await @updateLevel()
    @updateRatingEtc()

usersSchema.methods.setCfLogin = (cfLogin) ->
    logger.info "setting cf login ", @_id, cfLogin
    _debug_marker = {qwe: '255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255_255'}
    await @update({$set: {"cf.login": cfLogin}})
    @cf.login = cfLogin
    @updateCfRating()

usersSchema.methods.setUserList = (userList) ->
    logger.info "setting userList ", @_id, userList
    _debug_marker = {qwe: '256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256_256'}
    await @update({$set: {"userList": userList}})
    @userList = userList


usersSchema.statics.findByList = (list) ->
    User.find({userList: list}).sort({active: -1, "level.current": -1, ratingSort: -1})

usersSchema.statics.findAll = (list) ->
    User.find {}

usersSchema.statics.updateUser = (userId, dirtyResults) ->
    logger.info "Updating user", userId
    _debug_marker = {qwe: '257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257_257'}
    await updateResults(userId, dirtyResults)
    _debug_marker = {qwe: '258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258_258'}
    u = await User.findById(userId)
    _debug_marker = {qwe: '259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259_259'}
    await u.updateChocos()
    _debug_marker = {qwe: '260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260_260'}
    await u.updateRatingEtc()
    _debug_marker = {qwe: '261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261_261'}
    await u.updateLevel()
    logger.info "Updated user", userId

usersSchema.statics.updateAllUsers = (dirtyResults) ->
    _debug_marker = {qwe: '262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262_262'}
    users = await User.find {}
    promises = []
    for u in users
        promises.push(User.updateUser(u._id))
        if promises.length > 30
            logger.info("Updating 30 users, waiting for completion")
            _debug_marker = {qwe: '263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263_263'}
            await Promise.all(promises)
            logger.info("Updated 30 users, continuing")
            promises = []
    _debug_marker = {qwe: '264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264_264'}
    await Promise.all(promises)
    logger.info("Updated all users")

usersSchema.statics.updateAllCf = () ->
    logger.info "Updating cf ratings"
    _debug_marker = {qwe: '265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265_265'}
    for u in await User.findAll()
        if u.cf.login
            _debug_marker = {qwe: '266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266_266'}
            await u.updateCfRating()
            _debug_marker = {qwe: '267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267_267'}
            await sleep(500)  # don't hit CF request limit
    logger.info "Updated cf ratings"


usersSchema.index
    userList: 1
    active: -1
    level: -1
    ratingSort: -1

usersSchema.index
    username: 1

User = mongoose.model('Users', usersSchema);

export default User
