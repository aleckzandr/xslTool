using System;
using System.Collections;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace xsl
{
	/// <summary>
	/// Class to do main processing
	/// </summary>
	public class xsl
	{
		/// <summary>
		/// Main entry point for application
		/// </summary>
		/// <param name="args">array of <see cref="System.String"/></param>
		[STAThread]
		public static void Main(string[] args)
		{
			if (args.Length < 2)
			{
				Console.WriteLine("xsl input.xml input.xsl [outputfile] [n]");
				Console.WriteLine("[outputfile] & [n] optional");
				Console.WriteLine("[1] ASCIIEncoding");
				Console.WriteLine("[2] UnicodeEncoding default");
				Console.WriteLine("[3] UTF7Encoding");
				Console.WriteLine("[4] UTF8Encoding");
				return;
			}

			Encoding encodingToUse; // we will set it specifically below
			bool useStream = true; // assume we write to file, when false, we use a StringWriter and write to console

			try
			{
				if (args.Length == 4) // xsl input.xml input.xsl [outputfile] [n]
				{
					encodingToUse = GetEncoding(args[3]);
				}
				else if (args.Length == 3)
				{
					if (args[2].Length == 1) // find out if they want specific encoding
					{
						encodingToUse = GetEncoding(args[2]);
						useStream = false;
					}
					else // we're writing to file, use default encoding 
					{
						encodingToUse = new UnicodeEncoding();
					}
				}
				else
				{
					encodingToUse = new UnicodeEncoding(); // we are going to write to console, but we have to set it
					useStream = false;
				}

				// get our xsl and put it in xslBuilder
				var xslBuilder = new StringBuilder();
				var xslWriter = new StringWriter(xslBuilder);
				var xslReader = new StreamReader(args[1], true);
				xslWriter.Write(xslReader.ReadToEnd());

				long start, end; // for our time span
				string path = GetXSLDirPath(args[1]);

				DateTime dt = DateTime.Now;
				var xslArg = new XsltArgumentList();
				xslArg.AddParam("axslToday", string.Empty, dt.ToString("yyyy-MM-dd"));
				xslArg.AddParam("axslNow", string.Empty, dt.ToString("s"));
				xslArg.AddParam("axslGMT", string.Empty, dt.ToUniversalTime().ToString("r"));
				//xslArg.AddExtensionObject("http://aleckzandr.com/XsltExtension", new XsltExtension()); // for testing

				//Create the XslTransform and load the stylesheet.
				var xslt = new XslCompiledTransform(false); // XslCompiledTransform is "new" as of .NET 2.0 Framework! ;) this used to be "new XslTransform()"

				// Loading: Allow document function and scripting in Xslt Setting, and passing our Custom XmlResolver
				xslt.Load(args[1], new XsltSettings(true, true), new CustomResolver(path, xslBuilder.ToString())); // todo: I originally wrote this for .NET Framework 1.1, not sure if CustomResolver is needed any more

				var xmlWrterSettings = xslt.OutputSettings.Clone();
				xmlWrterSettings.CheckCharacters = false;

				if (useStream) // Note: we're using different overloads of xslt.Transform() method below
				{
					// use the stream writer
					using (var strmWriter = new StreamWriter(args[2], false, encodingToUse))
					{
						start = DateTime.Now.Ticks;

						xslt.Transform(XmlReader.Create(args[0]), xslArg, XmlWriter.Create(strmWriter, xmlWrterSettings));

						end = DateTime.Now.Ticks;
					}

					Console.WriteLine(string.Format("Transform (in ~{0} milliseconds) succeeded! Created file \"{1}\".", new TimeSpan(end - start).Milliseconds, args[2]));
				}
				else
				{
					var sb = new StringBuilder();

					// use the string writer
					using (var strngWriter = new StringWriter(sb))
					{
						start = DateTime.Now.Ticks;

						xslt.Transform(XmlReader.Create(args[0]), xslArg, XmlWriter.Create(strngWriter, xmlWrterSettings));

						end = DateTime.Now.Ticks;
					}

					Console.WriteLine(string.Format("{0}\nXSL Transform completed in ~{1} milliseconds.", sb.ToString(), new TimeSpan(end - start).Milliseconds));
				}
			}
			catch (Exception ex)
			{
				var errMessage = new StringBuilder(string.Format("xsl input.xml input.xsl [outputfile] [n]\nException Message: {0}\nSource: {1}", ex.Message, ex.Source));

				while (ex.InnerException != null)
				{
					errMessage.Append(string.Format("\nDescription: {0}", ex.InnerException.Message));
					ex = ex.InnerException;
				}

				Console.WriteLine(errMessage.ToString());
			}
		}

		/// <summary>
		/// Get directory path for Custom Resolver
		/// </summary>
		/// <param name="xslWholePath"><see cref="System.String"/></param>
		/// <returns><see cref="System.String"/></returns>
		/// <remarks>private</remarks>
		/// <remarks>Input C:\dev\hello.xsl, output C:\dev\ (including last back slash)</remarks>
		private static string GetXSLDirPath(string xslWholePath)
		{
			int j = xslWholePath.LastIndexOf('\\');
			if (j == -1)
			{
				string cd = Environment.CurrentDirectory;
				if (cd[cd.Length - 1] != '\\')
					cd += "\\";
				return cd;
			}
			else
				return xslWholePath.Substring(0, j + 1); // Note: last "\" is important! for GetEntity above
		}

		/// <summary>
		/// Returns a specific encoding: "1" = ASCIIEncoding, "2" (default) = UnicodeEncoding, "3" = UTF7Encoding, "4" = UTF8Encoding
		/// </summary>
		/// <param name="digit"></param>
		/// <returns></returns>
		private static Encoding GetEncoding(string digit)
		{
			Encoding retval;

			switch (digit)
			{
				case "1":
					retval = new ASCIIEncoding();
					break;
				case "3":
					retval = new UTF7Encoding();
					break;
				case "4":
					retval = new UTF8Encoding();
					break;
				default:
					retval = new UnicodeEncoding();
					break;
			}

			return retval;
		}
	}

	/// <summary>
	/// A custom XmlUrlResolver that we use for finding files (referenced through document function, or referenced in xsl etc)
	/// </summary>
	internal class CustomResolver : XmlUrlResolver
	{
		private static Hashtable memHash = new Hashtable();

		private Uri aUri;    // Uri to resolve
		private string ent;  // the entity - xml, xsl, css, etc

		/// <summary>
		/// ctor : please provide URI
		/// </summary>
		/// <param name="uri"></param>
		public CustomResolver(string uri) : base()
		{
			aUri = new Uri(uri);
		}

		/// <summary>
		/// ctor: please provide URI and the XSL entity
		/// </summary>
		/// <param name="uri"></param>
		/// <param name="xsl"></param>
		public CustomResolver(string uri, string xsl) : base()
		{
			aUri = new Uri(uri);
			ent = xsl;
		}

		/// <summary>
		/// Resolve : Resolves the absolute URI from the base and relative URIs, relativeUri can be absolute (replace) or relative (append)
		/// </summary>
		/// <param name="baseUri"></param>
		/// <param name="relativeUri"></param>
		/// <returns></returns>
		public override Uri ResolveUri(Uri baseUri, String relativeUri)
		{
			return base.ResolveUri(aUri, relativeUri);
		}

		/// <summary>
		/// Maps a URI to an object containing the actual resource. Utilizes a hashtable to store memory streams using the absoluteUri as a key
		/// </summary>
		/// <param name="absoluteUri"></param>
		/// <param name="role"></param>
		/// <param name="ofObjectToReturn"></param>
		/// <returns></returns>
		override public object GetEntity(Uri absoluteUri, string role, Type ofObjectToReturn)
		{
			if (memHash.ContainsKey(absoluteUri))

				return (MemoryStream)memHash[absoluteUri];

			else
			{
				//string resFile = absoluteUri.Segments[absoluteUri.Segments.Length - 1]; //.Replace("/", "");
				string absolute = absoluteUri.AbsolutePath;

				try
				{
					if (ent != null && (absolute == null || absolute == string.Empty || absolute[absolute.Length - 1] == '/'))
					{
						// XSL document('') function
						MemoryStream mStream = new MemoryStream(Encoding.Default.GetBytes(ent));
						memHash.Add(absoluteUri, mStream);
						return mStream;
					}
					else
						return base.GetEntity(absoluteUri, role, ofObjectToReturn);
				}
				catch (Exception ex)
				{
					Console.WriteLine(string.Format("GetEntity : {0}\n", ex.Message));
					throw ex;
				}
			}
		}
	}

	/// <summary>
	/// XSLT Extension Class
	/// </summary>
	public class XsltExtension
	{
		private int counter;
		private XmlDocument doc;

		#region Constructor
		/// <summary>
		/// Constructor for XsltExtension Class
		/// </summary>
		public XsltExtension()
		{
			doc = new XmlDocument();
			doc.LoadXml("<root><parent id=\"1\"><child id=\"1\">One</child><child id=\"2\">Two</child></parent><parent id=\"2\"><child id=\"3\">Three</child><child id=\"4\">Four</child></parent></root>");
			counter = 0;
		}
		#endregion

		#region Counter
		/// <summary>
		/// Set counter to value (and return value)
		/// </summary>
		/// <param name="value"><see cref="System.Int32"/></param>
		/// <returns><see cref="System.Int32"/></returns>
		public int InitCounter(int value)
		{
			counter = value;
			return counter;
		}

		/// <summary>
		/// Counter value
		/// </summary>
		/// <returns>see cref="System.Int32"/></returns>
		public int GetCounterValue()
		{
			return counter;
		}

		/// <summary>
		/// Increment counter and return value
		/// </summary>
		/// <returns><see cref="System.Int32"/></returns>
		public int IncrementCounter()
		{
			return ++counter;
		}
		#endregion

		#region GUID
		/// <summary>
		/// Return a GUID string with brackets and dashes
		/// </summary>
		/// <returns><see cref="System.String"/></returns>
		public string GetGUID()
		{
			return Guid.NewGuid().ToString("B");
		}

		/// <summary>
		/// Formatted GUID
		/// </summary>
		/// <param name="format"><see cref="System.String"/></param>
		/// <returns><see cref="System.String"/></returns>
		/// <remarks>format param: D = dashes and no brackets, B = brackets and dashes, N = neither dashes nor brackets</remarks>
		public string GetGUID(string format)
		{
			return Guid.NewGuid().ToString(format);
		}
		#endregion

		/// <summary>
		/// Test
		/// </summary>
		/// <returns><see cref="System.Xml.XPath.XPathNodeIterator"/></returns>
		public XPathNodeIterator GetXmlTest()
		{
			return doc.CreateNavigator().Select("/*");
		}

		/// <summary>
		/// Test
		/// </summary>
		/// <returns><see cref="System.Xml.XPath.XPathNodeIterator"/></returns>
		public XPathNodeIterator GetXmlTest(int id)
		{
			return doc.CreateNavigator().Select(string.Concat("/*/parent[@id=", id.ToString(), "]"));
		}
	}
}
