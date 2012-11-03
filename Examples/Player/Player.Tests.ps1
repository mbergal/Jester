Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 )

Describe  "Player" -Id "p" {
    Before `
        {
        . .\Player.ps1
        . .\Song.ps1

        $player = New-Player;
        $song = New-Song;

        function ShouldBePlaying
          {
          }
        }

    It "should be able to play a Song" {
       Start-Playing -Player $player -Song $song
       $player.CurrentlyPlayingSong | ShouldBe $song

       # demonstrates use of custom matcher
       $player | ShouldBePlaying;
       };

    Describe "when song has been paused" {
      Before `
        {
        Start-Playing $player $song;
        Pause-Playing $player;
        }

      It "should indicate that the song is currently paused" `
        {
#        $player.IsPlaying | ShouldBe $false

        # demonstrates use of 'not' with a custom matcher
#        $player.IsPlaying | ShouldNotBePlaying
        }

    It "should be possible to resume" `
        {
        Resume-Playing $player;
        player.isPlaying | Should-Be $true;
        player.CurrentlyPlayingSong | Should-Be $song;
        }
    }
  

  # // demonstrates use of spies to intercept and test method calls
  # it("tells the current song if the user has made it a favorite", function() {
  #   spyOn(song, 'persistFavoriteStatus');

  #   player.play(song);
  #   player.makeFavorite();

  #   expect(song.persistFavoriteStatus).toHaveBeenCalledWith(true);
  # });

  # demonstrates use of expected exceptions
  Describe "#resume" `
    {
    it "should throw an exception if song is already playing" `
      {
      Start-Playing $player $song;

      { Resume-Playing $player } | Should-Throw #"song is already playing"
      }
    }
  }

Invoke-Jester 