Add-Type -language CSharpVersion3 @'
public class JesterFailure
    {
    public string Expected { get; set; }
    public string Actual { get; set; }
    public string Difference { get; set; }
    
    public JesterFailure(string Expected, string Actual, string Difference )
        {
        this.Expected = Expected;
        this.Actual = Actual;
        this.Difference = Difference;
        }

    public override string ToString()
        {
        return string.Format("Expected: {0}\nBut was:  {1}\n{2}", Expected, Actual, Difference );
        }
    }
'@