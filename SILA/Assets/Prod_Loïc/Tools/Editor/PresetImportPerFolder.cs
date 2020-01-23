namespace RSTools
{
	using System.IO;
	using UnityEditor;
	using UnityEditor.Presets;

	public sealed class PresetImportPerFolder : AssetPostprocessor
	{
		void OnPreprocessAsset ()
		{
			if (assetImporter.importSettingsMissing)
			{
				var path = Path.GetDirectoryName (assetPath);

				while (!string.IsNullOrEmpty (path))
				{
					var presetGuids = AssetDatabase.FindAssets ("t:Preset", new[] { path });

					foreach (var presetGuid in presetGuids)
					{
						string presetPath = AssetDatabase.GUIDToAssetPath (presetGuid);
						if (Path.GetDirectoryName (presetPath) != path)
							continue;

						var preset = AssetDatabase.LoadAssetAtPath<Preset> (presetPath);
						if (preset.ApplyTo (assetImporter))
							return;
					}

					path = Path.GetDirectoryName (path);
				}
			}
		}
	}
}