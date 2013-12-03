Class Event:
  def __init__(self):
    self.status = 'pending_invited_my_turn'
  def getRsvp():
    if self.rsvp = "accept"
      return 1
    if self.rsvp = "decline"
      return -1
    else: 
      return 0

  
#Pendings
def getStatusOfDecline()
  if decline:
    return -1
  if accept:
    return 1
  else:
    return 0  #no response

def getVote(date_list):
  return vote_list # return from DB all the dates which the invitee voted on

def getStatusOfTurn(vote_list):
  if len(vote_list) == 0:
    return true  # meaning it is my turn
  else:
    return false

def getStatusOfCreator(event):
  if event.owner == user:
    return true
  else:
    return false

def updateVoteList():
  return #updated vote list from gui


def getStatusOfFinalization(date_list):
  if date_list == []:
    return false  #event can't be finalized if there is not date

if __name__ == '__main__':

# Created                       #Invited
  # pick time                     # respond
  # finalize time                 # waiting for event creator

is_event_creator = getStatusOfCreator(event) #bool
date_list        = getDateList(event) # list  can be null or all proposed times
is_finalized     = getStatusOfFinalization(date_list) #bool
pendingStatusList = ['needToPickDates','needToFinalize','votedAndNowWaiting','needToVote']

if is_event_creator:
  # Creator
  # example:  I need to go to the dentist.  
  # 1.  I create event with no time/date.  This will be in pendings/created/pick_times
  # 2.  I then pick a date/time (without finalization).  This will then be moved to pendings/created/finalize_times
  # 3.  I then finalize the date/time.  This is now moved to the calendar feed as confirmed
  # 4.  Step #3 can be skipped if the event creator doesn't select finalize time when selecting a date in the first place

  if is_finalized:
    self.status = 'Confirmed'
    print "This will be moved from pendings to a confirmed event in the calendar"
  else:
    if date_list == []:
      self.status = 'needToPickDates'
      print "This will be in pendings/created/pick_times"
    else:
      self.status = 'needToFinalize'
      print "This will be in pendings/created/finalize_times"

else: 
  #Invited
  # example:  I get asked to go to dinner and the event creator hasn't chosen any dates/times...so i just see a accept/reject button for the event
  # 1.  This will first be in pendings/invited/respond
  # 2.  Once I click accept this will move to pendings/invited/waiting for event creator
  # 3.  At the same time this will be resting in the event creators pendings/created/pick_time
  # 4.  Once the event creator picks some times, it will move into his directory pendings/created/finalize_times
  # 5.  At the same time for the invitee, it will move into pendings/invited/respond
  # 6.  After the invitee responds, it will move back into his pendings/invited/waiting for event creator
  # 7.  Whenever the event creator finalizes a time, it moves out of his pendings.  Now is most likely the time he will finalize but it could be before.
  # 8.  After invitee has voted and event creator has finalized time, then the event will be moved out of both the invitee and the creators pending list

  vote_list  = getVote(date_list)  # let invitee vote on date/times
  is_my_turn = getStatusOfTurn(vote_list)  #bool set to true if I haven't yet voted

  noGoodTimes = getStatusOfDecline()
  if noGoodTimes == -1:
    self.status = "Declined"  # will be removed from pendings and calendar feed
    return self.status

  if is_my_turn:
    has_date = len(date_list) > 0:  
    if has_date:  # check if the event has a date

      updateVoteList()
      if vote_list == []:
        self.status ="needToVote"
        print "user still hasn't responded to the event will stay in pendings/invtied/my_turn"
        return self.status

      if vote_list == [0]:
        self.status = "Not going"
        print "this event will now be removed from pendings and not be shown in your calendar feed"
        return self.status

      if is_finalized: # like a birthday party
        if vote_list == date_list[0]:  # if it's finalized then only 1 date in date list, and if my vote matches the only date, then it means i confirmed
          self.status = "Confirmed"
          print "congrats, you are going to the event.  This event will be removed from pendings and shown as a confirmed event in the calendar"
          return self.status
      if not is_finalized:
         self.status = "votedAndNowWaiting"
         print "You have voted, this will be moved into pendings/invited/eventcreator_turn, all dates/times will show up in gray in the calendar feed"
         return self.status

    if not has_date:
      # invitee can only accept/decline the event  
      self.updateRSVP()
      if self.rsvp == "accept"
        self.satus = "votedAndNowWaiting"
        print "thanks for accepting, now we are waiting for the event creator to pick some times, this will be moved to pending/invited/eventcreator_turn"   
      if self.rsvp == "decline"
        self.status="Declined"
        print "sorry you're not coming.  This will be removed from your pendings"

  if not is_my_turn:  
    # need to wait for event creator to finalize a time.  
    #Only thing invitee could do here is modify his vote or decline the event.  
    #By definition to get here means you had to vote
    # which means you accepted the event




