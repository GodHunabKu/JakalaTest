# -*- coding: utf-8 -*-
import ui
import chat

class HunterLevelWindow:
	"""
	Hunter Level Window - Versione minima con metodi Speed Kill
	"""

	def __init__(self):
		self.speedKillActive = False

	def Destroy(self):
		pass

	def IsShow(self):
		return False

	def Open(self):
		pass

	def Close(self):
		pass

	# ============================================================
	# SPEED KILL SYSTEM - Metodi richiesti
	# ============================================================

	def StartSpeedKill(self, mobType, duration, color):
		"""Avvia speed kill timer"""
		self.speedKillActive = True
		minutes = duration / 60
		chat.AppendChat(chat.CHAT_TYPE_INFO, "[SPEED KILL] %s - Uccidi entro %d:%02d per GLORIA x2!" % (mobType, minutes, duration % 60))

	def UpdateSpeedKillTimer(self, remainingSeconds):
		"""Aggiorna timer (chiamato ogni secondo)"""
		# Non stampiamo nulla per non spammare la chat
		pass

	def EndSpeedKill(self, isSuccess):
		"""Termina speed kill"""
		self.speedKillActive = False
		if isSuccess == 1 or isSuccess == "1":
			chat.AppendChat(chat.CHAT_TYPE_INFO, "[SPEED KILL SUCCESS] GLORIA x2!")
		else:
			chat.AppendChat(chat.CHAT_TYPE_INFO, "[SPEED KILL FAILED] Gloria normale")

	# ============================================================
	# STUB METHODS - Per compatibilità
	# ============================================================

	def OpenGateTrialWindow(self):
		pass

	def UpdateGateStatus(self, gateId, gateName, remainingSeconds, colorCode):
		pass

	def HideGateTimer(self):
		pass

	def OnGateComplete(self, success, gloriaChange):
		pass

	def OnTrialStart(self, trialId, trialName, toRank, colorCode):
		pass

	def OnTrialStatus(self, trialId, trialName, toRank, remainingTime, colorCode, status):
		pass

	def OnTrialProgress(self, trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions):
		pass

	def OnTrialComplete(self, newRank, gloriaReward, trialName):
		pass

	def ShowSystemMessage(self, msg, color):
		pass

	def ShowWelcomeMessage(self, rankKey, name, points):
		pass

	def ShowBossAlert(self, bossName):
		pass

	def ShowSystemInit(self):
		pass

	def ShowAwakening(self, playerName):
		pass

	def ShowHunterActivation(self, playerName):
		pass

	def ShowRankUp(self, oldRank, newRank):
		pass

	def ShowOvertake(self, overtakenName, newPosition):
		pass

	def ShowEventStatus(self, eventName, duration, eventType):
		pass

	def CloseEventStatus(self):
		pass

	def StartEmergencyQuest(self, title, seconds, vnum, count):
		pass

	def UpdateEmergencyCount(self, current):
		pass

	def EndEmergencyQuest(self, success):
		pass

	def UpdateRival(self, name, points, label, mode):
		pass

	def OpenWhatIf(self, qid, text, opt1, opt2, opt3, colorCode):
		pass

	def SetMissionsCount(self, count):
		pass

	def AddMissionData(self, missionData):
		pass

	def UpdateMissionProgress(self, missionId, current, target):
		pass

	def OnMissionComplete(self, missionId, name, reward):
		pass

	def OnAllMissionsComplete(self, bonus):
		pass

	def OpenMissionsPanel(self):
		pass

	def SetEventsCount(self, count):
		pass

	def AddEventData(self, eventData):
		pass

	def OnEventJoined(self, eventId, name, glory):
		pass

	def OpenEventsPanel(self):
		pass

	def StartFractureDefense(self, fractureName, duration, color):
		pass

	def UpdateFractureDefenseTimer(self, remainingSeconds):
		pass

	def CompleteFractureDefense(self, success, message):
		pass
